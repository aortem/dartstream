# ds_orm_base

`ds_orm_base` defines provider-neutral ORM adapter contracts for DartStream.
It lets applications use current Dart ORM and data-mapping packages while
keeping the DartStream persistence boundary stable.

## Purpose

Use this package when you want to:

- register an ORM adapter with DartStream
- expose typed repositories through a consistent contract
- keep migrations and schema lifecycle visible to the framework
- integrate current external ORM packages without making one ORM mandatory

This package does not implement an ORM. It defines the boundary that ORM
adapters should implement.

## Recommended Integration Direction

DartStream should prefer current, actively maintained Dart packages. Drift is a
good first adapter target for local, reactive SQLite use cases. PostgreSQL ORM
adapters can be added only after their package health, maintenance, and
framework fit are reviewed.

Server-side application frameworks that compete with DartStream should not be
documented as preferred ORM integrations.
