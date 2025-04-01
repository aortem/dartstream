# Lifecycle although in the extension folder is part of the core framework and does not have a manifest file

# Core Functionality:

- Lifecycle hooks (onStart, onStop, etc.) are foundational to the framework and likely used by all extensions.

# Extensibility:

The lifecycle module can provide APIs (e.g., LifecycleManager.registerHook()) that extensions interact with. This makes lifecycle a service offered by the core, rather than an extension itself.

# Avoid Circular Dependencies:

We've designed this to expose APIs that extensions can use to register hooks or respond to lifecycle events.