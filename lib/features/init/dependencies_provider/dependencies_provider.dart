import 'package:flutter/material.dart';
import 'package:selo/features/init/dependencies_provider/providers/blocs_provider.dart';
import 'package:selo/features/init/dependencies_provider/providers/repos_provider.dart';
import 'package:selo/features/init/dependencies_provider/providers/vms_provider.dart';

class DependenciesProvider extends StatelessWidget {
  const DependenciesProvider({Key? key, required this.builder})
    : super(key: key);
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return ReposProvider(
      child: BlocsProvider(
        child: VMsProvider(child: Builder(builder: builder)),
      ),
    );
  }
}
