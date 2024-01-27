import 'package:flutter/material.dart';
import 'package:metamask/utls/getChainName.dart';
import 'package:metamask/utls/chain.dart';
import 'package:metamask/utls/EIP155UIMethods.dart';
import 'package:metamask/utls/method_dialog.dart';
import 'package:metamask/utls/utls.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SessionWidget extends StatefulWidget {
  const SessionWidget({
    super.key,
    required this.w3mService,
    required this.launchRedirect,
  });

  final W3MService w3mService;
  final void Function() launchRedirect;

  @override
  SessionWidgetState createState() => SessionWidgetState();
}

class SessionWidgetState extends State<SessionWidget> {
  @override
  Widget build(BuildContext context) {
    
    final session = widget.w3mService.session;
    
    // final iconImage = session.sessionData?.peer.metadata.icons.first ?? '';
    final List<Widget> children = [
      const SizedBox(height: StyleConstants.linear16),
      // WALLET NAME LABEL
      Row(
        children: [
          // if (iconImage.isNotEmpty)
          //   CircleAvatar(
          //     radius: 50.0,
          //     backgroundImage: NetworkImage(iconImage),
          //   ),
          Expanded(
            child: Text(
              session?.connectedWalletName ?? '',
              style: Web3ModalTheme.getDataOf(context)
                  .textStyles
                  .large600
                  .copyWith(
                    color: Web3ModalTheme.colorsOf(context).foreground100,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      const SizedBox(height: StyleConstants.linear8),
      // TOPIC LABEL
      Visibility(
        // visible: session.topic != null,
        child: Column(
          children: [
            Text(
             "nv",
              style: Web3ModalTheme.getDataOf(context)
                  .textStyles
                  .small600
                  .copyWith(
                    color: Web3ModalTheme.colorsOf(context).foreground100,
                  ),
            ),
            Text(
         
              '${session?.topic}',
              style: Web3ModalTheme.getDataOf(context)
                  .textStyles
                  .small400
                  .copyWith(
                    color: Web3ModalTheme.colorsOf(context).foreground100,
                  ),
            ),
          ],
        ),
      ),
      Column(
        children: _buildSupportedChainsWidget(),
      ),
      const SizedBox(height: StyleConstants.linear8),
    ];

    // Get current active account
    final accounts = session?.getAccounts() ?? [];
      //  final accountss = session.getAccounts();
    try {
      final currentNamespace = widget.w3mService.selectedChain!.namespace;
      final chainsNamespaces = NamespaceUtils.getChainsFromAccounts(accounts);
      if (chainsNamespaces.contains(currentNamespace)) {
        final account = accounts.firstWhere(
          (account) => account.contains('$currentNamespace:'),
        );
        children.add(_buildAccountWidget(account));
      }
    } catch (e) {
      debugPrint('[$runtimeType] ${e.toString()}');
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(children: children),
    );
  }

  Widget _buildAccountWidget(String namespaceAccount) {
    final chainId = NamespaceUtils.getChainFromAccount(namespaceAccount);
    final account = NamespaceUtils.getAccount(namespaceAccount);
    final chainMetadata = getChainMetadataFromChain(chainId);

    final List<Widget> children = [
      Text(
        chainMetadata.w3mChainInfo.chainName,
        style: Web3ModalTheme.getDataOf(context).textStyles.title600.copyWith(
              color: Web3ModalTheme.colorsOf(context).foreground100,
            ),
      ),
      const SizedBox(height: StyleConstants.linear8),
      Text(
        account,
        style: Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
              color: Web3ModalTheme.colorsOf(context).foreground100,
            ),
      ),
    ];

    children.addAll([
      const SizedBox(height: StyleConstants.linear8),
      Text(
"Methods",
        style:
            Web3ModalTheme.getDataOf(context).textStyles.paragraph600.copyWith(
                  color: Web3ModalTheme.colorsOf(context).foreground100,
                ),
      ),
    ]);
    children.addAll(_buildChainMethodButtons(chainMetadata, account));

    children.addAll([
      const SizedBox(height: StyleConstants.linear8),
      Text(
        // ",mn,nnknkln",
      "event",
        style:
            Web3ModalTheme.getDataOf(context).textStyles.paragraph600.copyWith(
                  color: Web3ModalTheme.colorsOf(context).foreground100,
                ),
      ),
    ]);
    children.add(_buildChainEventsTiles(chainMetadata));

    return Container(
      padding: const EdgeInsets.all(StyleConstants.linear8),
      margin: const EdgeInsets.symmetric(vertical: StyleConstants.linear8),
      decoration: BoxDecoration(
        border: Border.all(color: chainMetadata.color),
        borderRadius: const BorderRadius.all(
          Radius.circular(StyleConstants.linear8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<Widget> _buildChainMethodButtons(
    ChainMetadata chainMetadata,
    String address,
  ) {
    // Add Methods
    // final approvedMethods =
    //     widget.w3mService.getApprovedMethods() ?? <String>[];
    // if (approvedMethods.isEmpty) {
    //   return [
    //     Text(
    //       'No methods approved',
    //       style: Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
    //             color: Web3ModalTheme.colorsOf(context).foreground100,
    //           ),
    //     )
    //   ];
    // }
    final usableMethods = EIP155UIMethods.values.map((e) => e.name).toList();
    //
final Map<String, String> approvedMethods = {
  'personal_sign': 'Send Message',
  'eth_sendTransaction': 'Send Transaction',
};

if (approvedMethods.isEmpty) {
      return [
        Text(
          'No methods approved',
          style: Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
                color: Web3ModalTheme.colorsOf(context).foreground100,
              ),
        )
      ];
    }

    final List<Widget> children = [];
  for (final entry in approvedMethods.entries) {
  final method = entry.key;
  final customName = entry.value;
      final implemented = usableMethods.contains(method);
      children.add(
        Container(
          // color: Colors.green,
          height: StyleConstants.linear40,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: StyleConstants.linear8),
          child: ElevatedButton(
            onPressed: implemented
                ? () async {
                    final future = callChainMethod(
                      chainMetadata.type,
                      EIP155.methodFromName(method),
                      chainMetadata,
                      address,
                    );
                    MethodDialog.show(context, customName, future);
                    widget.launchRedirect();
                  }
                : null,
            style: ButtonStyle(
              
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
          return Colors.black;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    StyleConstants.linear8,
                  ),
                ),
              ),
            ),
            child: Text(
              customName,
              style: Web3ModalTheme.getDataOf(context)
                  .textStyles
                  .small600
                  .copyWith(
                    color: Colors.white
                  ),
            ),
          ),
        ),
      );
    }

    if (chainMetadata.w3mChainInfo.chainId == '1') {
      children.add(
        Container(
          height: StyleConstants.linear40,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: StyleConstants.linear8),
          child: ElevatedButton(
            onPressed: () async {
              final future = EIP155.testContractCall(
                w3mService: widget.w3mService,
              );
              MethodDialog.show(context, 'Test TetherToken Contract', future);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(StyleConstants.linear8),
                ),
              ),
            ),
            child: Text(
              'Test TetherToken Contract',
              style: Web3ModalTheme.getDataOf(context)
                  .textStyles
                  .small600
                  .copyWith(
                    color: Web3ModalTheme.colorsOf(context).foreground100,
                  ),
            ),
          ),
        ),
      );
    }

    return children;
  }

  List<Widget> _buildSupportedChainsWidget() {
    List<Widget> children = [];
    children.addAll(
      [
        const SizedBox(height: StyleConstants.linear8),
        Text(
          'Supported chains:',
          style: Web3ModalTheme.getDataOf(context).textStyles.small600.copyWith(
                color: Web3ModalTheme.colorsOf(context).foreground100,
              ),
        ),
      ],
    );
    final approvedChains = widget.w3mService.getApprovedChains() ?? <String>[];
    children.add(
      Text(
        approvedChains.join(', '),
        style: Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
              color: Web3ModalTheme.colorsOf(context).foreground100,
            ),
      ),
    );
    return children;
  }

  Widget _buildChainEventsTiles(ChainMetadata chainMetadata) {
    // Add Events
    final approvedEvents = widget.w3mService.getApprovedEvents() ?? <String>[];
    if (approvedEvents.isEmpty) {
      return Text(
        'No events approved',
        style: Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
              color: Web3ModalTheme.colorsOf(context).foreground100,
            ),
      );
    }
    final List<Widget> children = [];
    for (final event in approvedEvents) {
      children.add(
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: StyleConstants.linear8,
            horizontal: StyleConstants.linear8,
          ),
          padding: const EdgeInsets.all(StyleConstants.linear8),
          decoration: BoxDecoration(
            border: Border.all(
              color: chainMetadata.color,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(StyleConstants.linear8),
            ),
          ),
          child: Text(
            event,
            style:
                Web3ModalTheme.getDataOf(context).textStyles.small400.copyWith(
                      color: Web3ModalTheme.colorsOf(context).foreground100,
                    ),
          ),
        ),
      );
    }

    return Wrap(
      children: children,
    );
  }

  Future<dynamic> callChainMethod(
    ChainType type,
    EIP155UIMethods method,
    ChainMetadata chainMetadata,
    String address,
  ) {
    final session = widget.w3mService.session!;
    switch (type) {
      case ChainType.eip155:
        return EIP155.callMethod(
          w3mService: widget.w3mService,
          topic: session.topic ?? '',
          method: method,
          chainId: chainMetadata.w3mChainInfo.namespace,
          address: address.toLowerCase(),
        );
      default:
        return Future<dynamic>.value();
    }
  }
}
