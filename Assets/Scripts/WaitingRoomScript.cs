using UnityEngine;
using System.Collections;

public class WaitingRoomScript : MonoBehaviour {

	public const string typeName = "RvsJ";
	public const string gameName = "#game123";
	
	static public bool isRefreshingHostList = false;
	static public HostData[] hostList;

	public static void RefreshHostList() {
		if (!isRefreshingHostList) {
			isRefreshingHostList = true;
			MasterServer.RequestHostList(typeName);
		}
	}

	public static void JoinServer(HostData hostData) {
		Network.Connect(hostData);
	}

	public static void StartServer(string name) {
		Network.InitializeServer(1, 25001, !Network.HavePublicAddress());
		MasterServer.RegisterHost(typeName, name);
	}

	void OnConnectedToServer() {
		if (Network.isClient) {
			Debug.Log ("client");
		} else if (Network.isServer) {
			Debug.Log ("sever");
		} else {
			Debug.Log ("#yoloswag");
		}
	}
}
