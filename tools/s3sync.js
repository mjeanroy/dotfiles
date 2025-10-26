#!/usr/bin/env node

//
// This script can be used to sync a local directory to a remote S3 buckets.
// This is mainly used for backups and archiving data for non frequent access (hence the default S3 storage class).
//
// Current usage:
//   `./s3sync.js "<local_directory>" "<remote_bucket>"`
//
// Examples: `./s3sync.js "/Users/mickael/photos" "s3://<bucket>/photos"
//

const path = require('node:path');
const fs = require('node:fs');
const child_process = require('node:child_process');
const util = require('node:util');

function run(cmd, quiet = false) {
  console.log('🙈 Running:', cmd);

  return new Promise((resolve, reject) => {
    const child = child_process.spawn(cmd, { shell: true });

    let stdout = '';
    let stderr = '';

    // Stream output live *and* store it
    child.stdout.on('data', (data) => {
      if (!quiet) {
        process.stdout.write(data);
      }

      stdout += data.toString();
    });

    child.stderr.on('data', (data) => {
      process.stderr.write(data);
      stderr += data.toString();
    });

    child.on('close', (code) => {
      if (code === 0) resolve({ stdout, stderr });
      else reject(new Error(`Command failed with code ${code}: ${stderr}`));
    });
  });
}

function appendSlash(name) {
  if (name.length === 0) {
    return '/';
  }

  if (name === '/') {
    return name;
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
      `aws s3 ls ${escapeShellArg(s3Uri)} --recursive --human-readable --color off`
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

function getDir(file) {
  const dir = path.dirname(file);
  return dir === '.' ? '' : dir;
}

function removeLeadingSlash(input) {
  return input.charAt(0) === '/' ? input.slice(1) : input;
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
    const dirDest = removeLeadingSlash(
      getDir(missingFile)
    );

    const dest = `s3://${path.join(s3Uri.slice('s3://'.length), appendSlash(dirDest))}`;
    const source = path.join(localDir, missingFile);

    console.log(`🔥 Uploading: ${missingFile}`)

    // Copy files
    const start = Date.now();

    await run(
      `aws s3 cp --storage-class GLACIER_IR ${escapeShellArg(source)} ${escapeShellArg(dest)}`
    );

    const end = Date.now();
    const durationMs = Date.now() - start;
    const durationS = durationMs / 1000;
    const formattedDuration = new Intl.NumberFormat("en").format(durationS);

    console.log(`✅ Uploaded: ${missingFile} (${formattedDuration} seconds)`);
    console.log('');
  }

  console.log(`🚀Sync Done!`)
}

main();

