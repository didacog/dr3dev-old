Contributing to DRLMv3
======================

How can I contribute?
---------------------

If you are interested in DRLMv3 development, is recommended to use the develompent environment
we prepared in this `repo <https://github.com/didacog/dr3dev>`_.

First of all you need to Fork DRLMv3 repos with your GitHub account.

Here the required repos you must fork from:

   * github.com/brainupdaters/drlm-core
   * github.com/brainupdaters/drlmctl
   * github.com/brainupdaters/drlm-common
   * github.com/brainupdaters/drlm-agent

After all forks are made, follow the `dr3dev instructions <https://github.com/didacog/dr3dev#requirements>`_.

Quick start summary (You must have pre-required software in place, see link above):

   1. Clone dr3dev repo
   ``git clone https://github.com/didacog/dr3dev && cd dr3dev``

   2. Build the docker images (1st time will take a while, coffe time? ;))
   ``make build-all``

   3. Start the development environment (1st time will take a while, enjoying coffe? ;))
   ``make start-all ghuser=<Github_User> gitname='Name Surname' gitmail='your@email.net'``
   Only 1st time you run ``make start-all`` all arguments are required to do a proper auto-setup
   of git, git-flow, etc. The following times no arguments are required and will be fast.

   4. Here you are in a container shell (godev).
   ``cd go/src/github.com/brainupdaters``
   Use ``code`` or ``nvim`` to develop, are pre-configured with the required plugins to work with.

   5. To stop development session. Exit you container shell after saving your work and run:
   ``make stop-all``
   Your work is safe in files directory of the repo. While you do not remove the repo folder or run
   ``make clean-all`` you will be able to continue developing with saved data from last session ;).

   5. Happy coding! ;)



 Reporting bugs
``````````````
Bug reports are submited through `GitHub Issues <https://guides.github.com/features/issues/>`_.

* Use a clear and descriptive title
* Describe the steps to reproduce the bug
* Attach the logs
* Describe the expected behaviour
* Be as specific as possible
* Specify which version of DRLM you're using
* Specify which OS you're using (both the server and the client)


F ixing a bug
````````````
If you want to fix a bug, you have to follow this steps:

1. **Fork DRLMv3 repos**

   First of all you need to Fork DRLMv3 repos with your GitHub account.

2. **Initialize DRLMv3 development environment**

   Read the Contributing instructions above.

   **Note**: Git and GitFlow setup is done automatically if followed the previous `instructions <https://github.com/didacog/dr3dev/blob/master/Docs/CONTRIBUTING.rst#how-can-i-contribute>`_.

3. **Create the new branch**

   First you need to create the branch you are going to work with in the target repo. The new version number is the same as the latest, but increasing by 1 the last number:
   ``git flow hotfix start <new.version.number>``

   For example, assuming latest version is 2.2.1:
   ``git flow hotfix start 2.2.2``

4. **Fix the bug**

   When commiting the changes, add a descriptive title and a brief description of what you have changed

5. **Make the Pull Request**

   When all you work is ready, you need to create the Pull Request. First you'll need to publish the branch:
   ``git flow hotfix publish``

   After publishing the branch, go to the `Brain Updaters DRLMv3 repositories <https://github.com/brainupdaters>`_ and make a new Pull Request from your ``feature/<feature-name>`` branch of your fork to the ``develop`` branch. Don't worry, we'll change your Pull Request to the correct branch. You might need to click ``compare between forks``.

   **Note**: in case you face merge conficts, you'll need to `Update your fork`_ and resolve the conficts locally.
   **Note**: in case you commit changes after executing ``git flow hotfix publish``, you'll need to execute ``git push`` in order to upload your latest changes to the Pull Request

6. **Cleanup**

   After the Pull Request is merged, remember to remove the branch in your local repository and in the GitHub.

   To delete the local branch, you need to execute:
   ``git checkout develop && git branch -d feature/<feature-name>``

   To delete the remote branch, you need to go to your fork page (``https://github.com/<your-username>/drlm-[core|common|cli|agent]``), click in ``branches``, next to the commits number, find your branch and delete it.

   Or do it directly through the command line:

   ``git push --delete feature/<feature-name>``

Suggesting new features or enhancements
```````````````````````````````````````
Suggestions are submited through `GitHub Issues <https://guides.github.com/features/issues/>`_.

* Use a clear and descriptive title
* Explain with detail the feature/enhancements
* Explain why the feature/enhancements would benefit the DRLM users


Adding a new functionality
``````````````````````````
If you want to add new functionality, you have to follow this steps:

1. **Fork DRLMv3 repos**

   First of all you need to Fork DRLMv3 repos with your GitHub account.

2. **Initialize DRLMv3 development environment**

   Read the Contributing instructions above.

   **Note**: Git and GitFlow setup is done automatically if followed the `instructions <https://github.com/didacog/dr3dev/blob/master/Docs/CONTRIBUTING.rst#how-can-i-contribute>`_.

4. **Create the new branch**

   After initializing Git Flow, you need to create the branch you are going to work with:
   ``git flow feature start <feature-name>``

   Example:
   ``git flow feature start web-ui``

5. **Program the functionality**

   When commiting the changes, add a descriptive title and a brief description of what you have changed

6. **Make the Pull Request**

   When all you work is ready, you need to create the Pull Request. First you'll need to publish the branch:
   ``git flow feature publish``

   After publishing the branch, go to the `Brain Updaters DRLMv3 repositories <https://github.com/brainupdaters>`_ and make a new Pull Request from your ``feature/<feature-name>`` branch of your fork to the ``develop`` branch. You might need to click ``compare between forks``.

   **Note**: in case you face merge conficts, you'll need to `Update your fork`_ and resolve the conficts locally.
   **Note**: in case you commit changes after executing ``git flow feature publish``, you'll need to execute ``git push`` in order to upload your latest changes to the Pull Request

7. **Cleanup**

   After the Pull Request is merged, remember to remove the branch in your local repository and in the GitHub.

   To delete the local branch, you need to execute:
   ``git checkout develop && git branch -d feature/<feature-name>``

   To delete the remote branch, you need to go to your fork page (``https://github.com/<your-username>/drlm-[core|common|cli|agent]``), click in ``branches``, next to the commits number, find your branch and delete it.

   Or do it directly through the command line:

   ``git push --delete feature/<feature-name>``


Style guidelines
----------------

Git Flow
````````
DRLM follows a `Git Flow <https://danielkummer.github.io/git-flow-cheatsheet>`_ workflow.


Semantic Versioning
```````````````````
DRLM uses `Semantic Versioning <https://semver.org>`_


Other
-----

Update your forks
`````````````````
If you have already forked DRLM and you want to update your fork to match the upstream repository, you have to follow this steps:

2. **Fetch the latest changes**

   In dr3dev godev container. Go to your drlm repos and download the latest changes from the upstream repository
   ``cd go/src/github.com/brainupdaters && for repo in core common cli agent; do cd drlm-$repo && git fetch upstream && cd ..; done``

   **Note**: The fetch from upstream is done automatically in godev container repos each time you start.

3. **Merge the changes**

   Finally, you need to merge the upstream changes to your repository. Keep in mind that the merge is specific depending on the branch you are:
   ``git merge upstream/<current-branch>``

   For example, assuming you are in the develop branch:
   ``git merge upstream/develop``


