const prettier = require("prettier");
const crypto = require("crypto");
const sha256 = (text) => crypto.createHash("sha256").update(text).digest("hex");
const fs = require("fs");
const process = require("process");
const path = require("path");
const repoRoot = path.resolve(__dirname, "..");
const distDir = path.resolve(repoRoot, "dist");
const logDir = path.resolve(repoRoot, "logs");
const { promisify } = require("util");
const glob = require("glob");
const readdir = promisify(fs.readdir);
const readFile = promisify(fs.readFile);
const writeFile = promisify(fs.writeFile);
const appendFile = promisify(fs.appendFile);
const ProgressBar = require("progress");

const logger = (version) => {
  const logFile = path.resolve(logDir, `prettier.${version}.log`);
  return async (msg) => await appendFile(logFile, msg);
};

const index = {};
const prettify = async (filePath) => {
  const contents = await readFile(filePath, { encoding: "utf8" });
  const hash = sha256(contents);
  let cached = index[hash];
  if (prettier.check(contents, { parser: "html" })) return;

  const result = cached
    ? await readFile(cached, { encoding: "utf8" })
    : prettier.format(contents, { parser: "html" });
  await writeFile(filePath, result);
  if (!cached) index[hash] = filePath;
};
const main = async () => {
  const versions = await readdir(distDir);
  let vn = -1;
  for (const version of versions.slice(11)) {
    vn += 1;
    const log = logger(version);
    /** @type string[] */
    const htmlFiles = await new Promise((resolve, reject) =>
      glob(`${distDir}/${version}/**/*.html`, (err, files) =>
        err ? reject(err) : resolve(files)
      )
    ).catch((e) => log(e));
    if (htmlFiles.length === 0) console.log(`empty version ${version}`);
    else {
      const bar = new ProgressBar(
        ":bar :current / :total :percent :version :vn / :vt :file ",
        {
          total: htmlFiles.length,
          width: 30,
        }
      );

      for (const file of htmlFiles) {
        try {
          bar.tick({
            version,
            file: file.replace(`{distDir}/${version}/`, ""),
            vn,
            vt: versions.length,
          });
          await prettify(file);
        } catch (e) {
          log(`\n\nfile: ${file}\n${e}`);
        }
      }
    }
  }
};

main().then(() => {
  console.log(index);
});
