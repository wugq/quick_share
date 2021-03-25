import "dart:io";

class CommonTools {
  static Future<List<InternetAddress>> getIPList() async {
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: true, includeLinkLocal: true);

    List<List<InternetAddress>> addressListList =
        interfaces.map((e) => e.addresses).toList();
    List<InternetAddress> addressList =
        addressListList.expand((i) => i).toList();
    return addressList;
  }
}
