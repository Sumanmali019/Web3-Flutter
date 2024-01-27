import 'package:flutter/material.dart';
import 'package:metamask/utls/session_helper.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() async {
    W3MChainPresets.chains.putIfAbsent('42220', () => _exampleCustomChain);
    _w3mService = W3MService(
      projectId: "91fea5ea39fc5898af040c6fd6c478c2",
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: "W3M Flutter",
        description: "W3M connect",
        url: 'https://web3modal.com/',
        icons: ['https://raw.githubusercontent.com/WalletConnect/Web3ModalFlutter/master/assets/AppIcon.png'],
        redirect: Redirect(
          native: 'web3modalflutter://',
          universal: 'https://web3modal.com',
        ),
      ),
    );
  await _w3mService.init();

    _w3mService.addListener(_serviceListener);
    _w3mService.web3App?.onSessionEvent.subscribe(_onSessionEvent);
    _w3mService.web3App?.onSessionUpdate.subscribe(_onSessionUpdate);
    _w3mService.web3App?.onSessionConnect.subscribe(_onSessionConnect);
    _w3mService.web3App?.onSessionDelete.subscribe(_onSessionDelete);

  }

  @override
  void dispose() {
       _w3mService.web3App?.onSessionEvent.unsubscribe(_onSessionEvent);
    _w3mService.web3App?.onSessionUpdate.unsubscribe(_onSessionUpdate);
     _w3mService.web3App?.onSessionConnect.unsubscribe(_onSessionConnect);
      _w3mService.web3App?.onSessionDelete.unsubscribe(_onSessionDelete);
    super.dispose();
  }

  void _serviceListener() {
    setState(() {});
  }

  void _onSessionEvent(SessionEvent? args) {
    debugPrint('[$runtimeType] _onSessionEvent $args');
  }

  void _onSessionUpdate(SessionUpdate? args) {
    debugPrint('[$runtimeType] _onSessionUpdate $args');
  }

  void _onSessionConnect(SessionConnect? args) {
    debugPrint('[$runtimeType] _onSessionConnect $args');
  }

  void _onSessionDelete(SessionDelete? args) {
    debugPrint('[$runtimeType] _onSessionDelete $args');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.square(dimension: 4.0),
              _ButtonsView(w3mService: _w3mService),
              const Divider(height: 0.0, color: Colors.transparent),
              _ConnectedView(w3mService: _w3mService)
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _ButtonsView extends StatelessWidget {
  final W3MService w3mService;
  const _ButtonsView({required this.w3mService});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        W3MConnectWalletButton(service: w3mService),
        const SizedBox.square(dimension: 8.0),
      ],
    );
  }
}

class _ConnectedView extends StatelessWidget {
  const _ConnectedView({required this.w3mService});
  final W3MService w3mService;

  @override
  Widget build(BuildContext context) {
    if (!w3mService.isConnected) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox.square(dimension: 12.0),
        W3MAccountButton(service: w3mService),
        SessionWidget(
          w3mService: w3mService,
          launchRedirect: () {
           w3mService.
           launchConnectedWallet();
          }, 
        ),
        const SizedBox.square(dimension: 12.0),
      ],
    );
  }
}



const _chainId = "42220";
final _exampleCustomChain = W3MChainInfo(
  chainName: 'Celo',
  namespace: 'eip155:42220',
  chainId: '42220',
  tokenName: 'CELO',
  rpcUrl: 'https://forno.celo.org/',
  blockExplorer: W3MBlockExplorer(
    name: 'Celo Explorer',
    url: 'https://explorer.celo.org/mainnet',
  ),
);
