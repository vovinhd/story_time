import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/tray.dart' as tray;
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SettingsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// TODO hook up to things
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        onClose: (p0) => tray.hideOrClose(),
        title: Text("Settings"),
        leading: YaruBackButton(),
        actions: [SizedBox(height: 34, width: 34)],
      ),

      body: Center(
        child: Container(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var multiline = constraints.maxWidth < 500;
                // print(constraints);
                return ListView(
                  children: [
                    SettingsSection(
                      title: "Player Settings",
                      children: [
                        LabeledSettinsRow(
                          label: "Skip buttons duration",
                          sublabel: "How much time the skip buttons should seek the play position by",
                          multiline: false,
                          actionWidget: DropdownButton<Duration>(
                            items: [
                              DropdownMenuItem(
                                value: Duration(seconds: 10),
                                child: Text("10 sec"),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 30),
                                child: Text("30 sec"),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 60),
                                child: Text("1 min"),
                              ),
                            ],
                            value: ConfigProvider().config.skipDuration,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.skipDuration =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        LabeledSettinsRow(
                          label: "Unskip timeout",
                          sublabel: "how long the unskip button stays visible after seeking",
                          actionWidget: DropdownButton<Duration>(
                            items: [
                              DropdownMenuItem(
                                value: Duration(seconds: 3),
                                child: Text("3 sec"),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 5),
                                child: Text("5 sec"),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 10),
                                child: Text("10 sec"),
                              ),
                            ],
                            value: ConfigProvider().config.unksipTimeout,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.unksipTimeout =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        // LabeledSettinsRow(
                        //   label: "Reduce animations",
                        //   sublabel: "remove page transitions to prevent nausea",
                        //   actionWidget: Switch(
                        //     value: reduceAnimations,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         reduceAnimations = value;
                        //       });
                        //     },
                        //   ),
                        // ),

                        // LabeledSettinsRow(
                        //   label: "Performance mode",
                        //   sublabel: "Make the app less pretty for more fast",
                        //   actionWidget: Switch(
                        //     value: ConfigProvider().config.performanceMode,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         ConfigProvider().config.performanceMode = value;
                        //         ConfigProvider().SaveConfig();
                        //         ConfigProvider().notify();
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    SettingsSection(
                      title: "System Integration",
                      subttile: "Settings that are more born from my commitment issues than for being necessary",
                      children: [
                        LabeledSettinsRow(
                          label: "Minimize to systemtray",
                          sublabel: "Keep player in system tray instead of quitting when main window is closed",
                          actionWidget: DropdownButton<SystemTrayUsage>(
                            items: [
                              DropdownMenuItem(
                                value: SystemTrayUsage.always,
                                child: Text("Always"),
                              ),

                              DropdownMenuItem(
                                value: SystemTrayUsage.whenPlaying,
                                child: Text("When Playing"),
                              ),

                              DropdownMenuItem(
                                value: SystemTrayUsage.never,
                                child: Text("Never"),
                              ),
                            ],
                            value: ConfigProvider().config.systemTrayUsage,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.systemTrayUsage =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        // LabeledSettinsRow(
                        //   label: "Enable DBus integration",
                        //   sublabel: "Show player status on lock screen etc.",
                        //   actionWidget: Switch(
                        //     value: ConfigProvider().config.enableDBus,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         ConfigProvider().config.enableDBus = value;
                        //         ConfigProvider().SaveConfig();
                        //         ConfigProvider().notify();
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),

                    SettingsSection(
                      title: "Danger Zone",
                      subttile: "Destructive actions",
                      children: [
                        LabeledSettinsRow(
                          label: "Clear cache",
                          sublabel: "Deletes cached cover images",
                          actionWidget: FilledButton(
                            style: Theme.of(context).filledButtonTheme.style,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete cache"),
                                content: const Text(
                                  "Really delete cached coved images?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                                                            ConfigProvider().deleteCache(); 

                                      Navigator.pop(context, 'OK');
                                    },
                                    child: Text("Do it"),
                                  ),
                                ],
                              ),
                            ),
                            child: Text("Clear Cache"),
                          ),
                        ),

                        LabeledSettinsRow(
                          label: "Delete history",
                          sublabel: "deletes all playback positions in your audiobooks",
                          actionWidget: FilledButton(
                            style: Theme.of(context).filledButtonTheme.style,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete history"),
                                content: const Text(
                                  "deletes all playback positions in your audiobooks. Leaves the .m4h files where they are.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ConfigProvider().deleteHistory();
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: Text("Do it"),
                                  ),
                                ],
                              ),
                            ),
                            child: Text("Delete History"),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    this.subttile,
    required this.children,
  });

  final String title;
  final String? subttile;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SectionLabel(label: title, sublabel: subttile),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [...children],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const new({super.key, required this.label, this.sublabel});

  final String label;
  final String? sublabel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(label, style: .new(fontWeight: .bold)),
          sublabel != null
              ? Text(
                  sublabel!,
                  style: .new(fontSize: 14, color: YaruColors.warmGrey),
                  softWrap: true,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class LabeledSettinsRow extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    this.sublabel,
    required this.actionWidget,
    this.multiline = false,
  });

  final String label;
  final String? sublabel;
  final multiline;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    if (multiline) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(label, style: .new(fontWeight: .bold)),
                    sublabel != null
                        ? Text(
                            sublabel!,
                            style: .new(
                              fontSize: 14,
                              color: YaruColors.warmGrey,
                            ),
                            softWrap: true,
                          )
                        : SizedBox(),
                  ],
                ),
                actionWidget,
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: .new(fontWeight: .bold)),
                if (sublabel != null)
                  Text(
                    sublabel!,
                    style: .new(fontSize: 14, color: YaruColors.warmGrey),
                    softWrap: true,
                  )
                else
                  SizedBox(),
              ],
            ),
          ),
          actionWidget,
        ],
      ),
    );
  }
}
