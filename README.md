# Share MD MkDocs container

This Dockerfile builds the MkDocs R2 experimental backend using the Share MD repository root as the Docker build context. It requires the parent repository's application, builder script, static assets, requirements, and initialized LaTeX theme submodule.

The container mounts the configured R2 bucket using tigrisfs for the experimental build. FUSE support and bucket read/write credentials are required at runtime.
