#!/usr/bin/env node

const path = require('node:path');
const fs = require('node:fs');
const child_process = require('node:child_process');
const util = require('node:util');
const exec = util.promisify(child_process.exec);

async function run(cmd) {
  console.log('🙈 Running: ', cmd);
  return await exec(cmd, {
    encoding: "utf-8",
  });
}

function appendSlash(name) {
  if (name.length === 0) {
    return '/';
  }

  return name.at(-1) === '/' ? name : `${name}/`;
}

function escapeShellArg (arg) {
  return `"${arg.replace(/"/g, `"\\""`)}"`;
}

async function localDirectoryFiles(dir) {
  console.log('⌛ Getting content of:', dir);

  const normalizedDir = appendSlash(dir);
  const files = await fs.promises.readdir(normalizedDir, {
    recursive: true,
    withFileTypes: true,
    encoding: 'utf-8',
  });

  return files
    .filter((f) => f.isFile())
    .filter((f) => f.name.at(0) !== '.')
    .map((f) => path.join(f.parentPath, f.name))
    .map((f) => f.slice(normalizedDir.length));
}

async function s3ls(s3Uri) {
  try {
    const { stdout } = await run(
      `aws s3 ls ${escapeShellArg(s3uri)} --recursive --human-readable --color off`
    );

    return stdout;
  } catch {
    return '';
  }
}

async function bucketFiles(s3uri) {
  console.log('⌛ Getting content of:', s3uri);

  const [,,, ...dirs] = s3uri.split('/');
  const dir = appendSlash(dirs.join('/'));

  const stdout = await s3ls(s3uri);
  return stdout.split('\n')
    .map((line) => line.slice(30))
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .filter((line) => line.at(-1) !== '/')
    .filter((line) => line.startsWith(dir))
    .map((line) => line.slice(dir.length));
}

async function main() {
  const args = process.argv.slice(2);

  if (args.length !== 2) {
    throw new Error(
      'Arguments should be <dir> <bucket>'
    );
  }

  const [localDir, s3Uri] = args;

  if (!s3Uri.startsWith('s3://')) {
    throw new Error('Bucket does not start with s3 uri scheme: ' + s3Uri);
  }

  const remoteFiles = await bucketFiles(s3Uri);
  const localFiles = await localDirectoryFiles(localDir);

  const missingFiles = new Set(localFiles);
  for (const remoteFile of remoteFiles) {
    missingFiles.delete(remoteFile);
  }

  console.log('➡️ Files to upload:');
  for (const missingFile of missingFiles) {
    console.log(`  ${missingFile}`);
  }

  console.log('');

  for (const missingFile of missingFiles) {
    const dirDest = missingFile.slice(0, missingFile.lastIndexOf('/'));
    const dest = `s3://${path.join(s3Uri.slice('s3://'.length), appendSlash(dirDest))}`;
    const source = path.join(localDir, missingFile);

    console.log(`🔥 Uploading: ${missingFile}`)

    await run(
      `aws s3 cp ${escapeShellArg(source)} ${escapeShellArg(dest)}`
    );

    console.log(`✅ Uploaded: ${missingFile}`);
    console.log('');
  }

  console.log(`🚀Sync Done!`)
}

main();

