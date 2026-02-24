const vscode = require("vscode");

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  console.log("DartStream Extension is now active!");

  // Hello World Command
  let helloWorld = vscode.commands.registerCommand(
    "dartstream.helloWorld",
    function () {
      vscode.window.showInformationMessage(
        "🚀 Welcome to DartStream! Your IDE setup is ready.",
      );
    },
  );

  // Initialize Project Command (Simulator Mode)
  let initProject = vscode.commands.registerCommand(
    "dartstream.initProject",
    async function () {
      const projectName = await vscode.window.showInputBox({
        prompt: "Enter project name",
        placeHolder: "my_dartstream_app",
      });

      if (!projectName) return;

      vscode.window.withProgress(
        {
          location: vscode.ProgressLocation.Notification,
          title: "DartStream: Initializing project...",
          cancellable: false,
        },
        (progress) => {
          return new Promise((resolve) => {
            setTimeout(() => {
              progress.report({
                increment: 100,
                message: `Done! Project ${projectName} created.`,
              });
              vscode.window.showInformationMessage(
                `✅ Project "${projectName}" initialized successfully (Simulator Mode).`,
              );
              resolve();
            }, 2000);
          });
        },
      );
    },
  );

  context.subscriptions.push(helloWorld);
  context.subscriptions.push(initProject);
}

function deactivate() {}

module.exports = {
  activate,
  deactivate,
};
