# How This Structure Works

## Discovery System:

The discovery logic scans all subdirectories under auth/providers/ (e.g., google, amazon) to find manifest.yaml files.

Each provider (e.g., Google, Amazon) is treated as a separate extension and registered independently.
Core Logic in auth/base:

The auth/base folder contains reusable logic (e.g., AuthManager class or interface) that all providers rely on.
Providers like google and amazon extend or implement these base classes.
Flexibility for Providers:

Providers like google and amazon can:

Have their own dependencies (managed in their pubspec.yaml).

Be maintained, tested, or even published independently, if needed.

# Advantages of This Structure

## Scalability:

Adding new providers (e.g., Azure, Okta) is as simple as creating a new folder under providers, adding the implementation in lib/, and defining a manifest.yaml.
Encapsulation:

Each provider is self-contained, with no unnecessary dependencies on others.
Providers can evolve independently without impacting the core auth module.
Consistency:

The manifest.yaml ensures every provider follows the same structure and can be discovered and registered seamlessly.