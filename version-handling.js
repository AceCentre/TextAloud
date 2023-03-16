const fs = require("fs");
const path = require("path");

const getNewVersion = () => {
  const [major, minor, patch] = currentVersion.split(".");

  if (commit.includes("[PATCH]")) {
    return `${major}.${minor}.${parseInt(patch) + 1}`;
  } else if (commit.includes("[MINOR]")) {
    return `${major}.${parseInt(minor) + 1}.${0}`;
  } else if (commit.includes("[MAJOR]")) {
    return `${parseInt(major) + 1}.${0}.${0}`;
  } else {
    return null;
  }
};

module.exports = ({ github, context, core }) => {
  console.log({ github, context, core });

  const projectFilePath = path.join(
    __dirname,
    "./TextAloud.xcodeproj/project.pbxproj"
  );

  console.log(`Getting project file: ${projectFilePath}`);

  const contents = fs
    .readFileSync(projectFilePath, {
      encoding: "utf8",
    })
    .toString();

  const regex = new RegExp(/MARKETING_VERSION = (\d+\.\d+\.\d+);/, "g");

  const results = contents.matchAll(regex);

  let count = 0;
  let currentVersion = null;

  for (const result of results) {
    if (count == 0) {
      currentVersion = result[1];
    } else {
      if (result[1] !== currentVersion)
        throw new Error("All versions didn't match");
    }
    count++;
  }

  if (count !== 4) throw new Error("Didn't find four entries of the version");

  console.log("Current version is: ", currentVersion);

  const newVersion = getNewVersion();

  if (newVersion === null) {
    console.log("You didn't ask for a new version");
  } else {
    console.log("New version", newVersion);

    const newContents = contents.replaceAll(currentVersion, newVersion);

    fs.writeFileSync(projectFilePath, newContents);
  }
};
