import 'package:flutter/material.dart';
import 'package:task_4/screens/second_page.dart';
import 'package:task_4/services/remote_config_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final RemoteConfigService remoteConfig;

  Map<String, dynamic> variables = {};

  @override
  void initState() {
    super.initState();
    remoteConfig = RemoteConfigService();
    initializeConfig();
    listenForConfigChanges();
  }

  Future<void> initializeConfig() async {
    Map<String, dynamic> mapVariables = await remoteConfig.initializeConfig();
    setState(() {
      variables = mapVariables;
    });
  }

  void listenForConfigChanges() async{
    
    remoteConfig.remoteConfig.onConfigUpdated.listen((_) async{
      remoteConfig.initializeConfig();
        setState(() {
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: RemoteConfigService().initializeConfig(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final variables = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (variables['isHidden'] == false)
                    Image.asset(
                      variables['assetString'],
                      height: 300,
                      width: 300,
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    variables['eurovisionString'] ??
                        'Default Eurovision String',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(variables['yearNumber'].toString()),
                  ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SecondPage()));
                  }, 
                  child: const Text("SecondPage")),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
