using UnityEngine;
using System.Collections;

public class TitleGUIHandler : MonoBehaviour {

	// Use this for initialization
	void Start () {
		WaitingRoomScript.RefreshHostList();
	}

	// Update is called once per frame
	void Update () {
		if (WaitingRoomScript.isRefreshingHostList && MasterServer.PollHostList().Length > 0)
		{
			WaitingRoomScript.isRefreshingHostList = false;
			WaitingRoomScript.hostList = MasterServer.PollHostList();
		}
	}
	
	void OnGUI () {

		if (GUI.Button (new Rect((int)(Screen.width / 2) - 150, 125, 300, 25), "Story")) {
			Application.LoadLevel(3);
		}

		//Create Lobby - Push player to game scene
		if (GUI.Button (new Rect((int)(Screen.width / 2) - 150, 200, 300, 25), "Create Game")) {
			WaitingRoomScript.StartServer(System.Environment.UserName);
			Application.LoadLevel(2);
		}

		//Create lobby list - Push player to game scene
		int i = 0;
		if (WaitingRoomScript.hostList != null) {
			for (i = 0; i < WaitingRoomScript.hostList.Length; i++)
			{
				if (GUI.Button(new Rect((int)(Screen.width / 2) - 150, 175 + (50 * (i+1)), 300, 50), WaitingRoomScript.hostList[i].gameName)) {
					WaitingRoomScript.JoinServer(WaitingRoomScript.hostList[i]);
				}
			}
		}

		GUI.Box(new Rect((int)(Screen.width / 2) - 160, 165 + 10, 320, 10 + (50 * (i+1))), "Games");

		if (GUI.Button (new Rect ((int)(Screen.width / 2) - 100, 175 + (50 * (i+1)) + 10, 200, 25), "Refresh")) {
			WaitingRoomScript.RefreshHostList();
		}



		if (GUI.Button (new Rect ((int)Screen.width - 80, 20, 60, 40), "Exit")) {
			Application.Quit();
		}

	}
	
	
}
