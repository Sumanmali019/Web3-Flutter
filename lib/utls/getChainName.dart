import 'package:flutter/material.dart';
import 'package:metamask/utls/helper.dart';
import 'package:web3modal_flutter/utils/w3m_chains_presets.dart';

import 'chain.dart';

String getChainName(String chain) {
  try {
    return ChainDataWrapper.chains
        .where((element) => element.w3mChainInfo.namespace == chain)
        .first
        .w3mChainInfo
        .chainName;
  } catch (e) {
    debugPrint('getChainName, Invalid chain: $chain');
  }
  return 'Unknown';
}

ChainMetadata getChainMetadataFromChain(String namespace) {
  try {
    return ChainDataWrapper.chains
        .where((element) => element.w3mChainInfo.namespace == namespace)
        .first;
  } catch (_) {
    return ChainMetadata(
      color: Colors.grey,
      type: ChainType.eip155,
      w3mChainInfo: W3MChainPresets.chains.values.firstWhere(
        (e) => e.namespace == namespace,
      ),
    );
  }
}
