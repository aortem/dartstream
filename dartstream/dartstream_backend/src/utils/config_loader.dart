/* 
Managing Configuration
Global Configuration Directory:

Consider creating a global /config directory at a higher level (possibly at the root of the backend directory or even higher depending on your project's scope). This directory would contain configuration files that are applicable regardless of which middleware is used.

This /config directory can contain environment-specific settings, middleware-specific settings, and other global settings that need to be easily accessible and modifiable.
Middleware-Specific Configuration:

Each middleware directory (shelf and custom_middleware) can also include its own local configuration files that override or extend the global settings when necessary. This allows for flexibility and customization for each middleware type.

Example: tooling/shelf/config.yaml and tooling/custom_middleware/config.yaml for middleware-specific settings.
CLI Tool for Configuration Management:

Enhance the cli_util package to include functionality that helps users to configure and switch between different middleware easily. This could involve CLI commands to initialize or modify the configurations.
Example CLI commands could be: ds config --middleware=shelf or ds config --middleware=custom which would set up or modify the necessary configuration files accordingly.

Configurability and Environment Handling:

/config: Introduce a config directory for environment-specific settings, which can be different depending on the middleware used.
This would help in managing different configurations that your application might need when deploying with different middleware options.


*/