# Retire a completed docs preview

Docs preview channels can fill the Firebase site quota even after their source
has merged. `firebase:stop_preview_docs` provides a manual, exact-source cleanup
path. It never deletes a source branch or changes the live/development/qa channel.

Before starting the stop job, verify the source commit is integrated, there is no
active source MR, and no QA item or human review still depends on the preview.
Record the current channel, source, MR/dependency checks and cleanup receipt in
the existing executor run. Do not retire an active preview merely to free quota.

Start the stop job in the completed source pipeline with the manual variable
`DOCS_PREVIEW_RETIREMENT_CONFIRMED` set to its full source branch with `/` replaced
by `-`. The confirmation is required even if GitLab invokes the environment stop
action automatically. Missing or mismatched confirmation fails before deletion.
The job retrieves its helper from the exact pipeline SHA, so cleanup does not
require the old source branch to remain available for checkout.

After the job succeeds, independently list the site's channels and verify the
specified preview is absent and capacity is released. Only then retry the exact
failed preview prerequisite once and inspect its parent, siblings and recursive
children. Full approvals, QA and merge gates still apply.

Existing channels created before this job was available require their existing
authorized lifecycle or a separate owner-approved retirement. This change does
not authorize bulk cleanup or retroactively supply stop jobs to old pipelines.

References: https://firebase.google.com/docs/hosting/manage-hosting-resources
and https://docs.gitlab.com/ci/environments/.
