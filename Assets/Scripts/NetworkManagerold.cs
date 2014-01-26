using UnityEngine;
using System.Collections;

public class NetworkManagerold : MonoBehaviour
{
    private const string typeName = "UniqueGameName";
    private const string gameName = "RoomName";

	public GameObject gameManager;
	public GUITexture SplashTexture;
    private bool isRefreshingHostList = false;
    private HostData[] hostList;


	public Vector3[] playerSpawns;

    public GameObject playerPrefab;

    void OnGUI()
    {
        if (!Network.isClient && !Network.isServer)
        {
            if (GUI.Button(new Rect(100, 100, 250, 100), "Start Server")) {
                StartServer();
				SplashTexture.active = false; 
			}
            if (GUI.Button(new Rect(100, 250, 250, 100), "Refresh Hosts")) {
                RefreshHostList();
			}
            if (hostList != null)
            {
                for (int i = 0; i < hostList.Length; i++)
                {
                    if (GUI.Button(new Rect(400, 100 + (110 * i), 300, 100), hostList[i].gameName)) {
                        JoinServer(hostList[i]);
						SplashTexture.active = false; 

					}
                }
            }
        }
    }

    private void StartServer()
    {
        Network.InitializeServer(5, 25000, !Network.HavePublicAddress());
        MasterServer.RegisterHost(typeName, gameName);
    }

    void OnServerInitialized()
    {
        SpawnPlayer();
    }


    void Update()
    {
        if (isRefreshingHostList && MasterServer.PollHostList().Length > 0)
        {
            isRefreshingHostList = false;
            hostList = MasterServer.PollHostList();
        }
    }

    private void RefreshHostList()
    {
        if (!isRefreshingHostList)
        {
            isRefreshingHostList = true;
            MasterServer.RequestHostList(typeName);
        }
    }


    private void JoinServer(HostData hostData)
    {
        Network.Connect(hostData);
    }

    void OnConnectedToServer()
    {
        SpawnPlayer();
    }


    private void SpawnPlayer() {

		//Create an instance of the player and spawn him in one of the spawn points
		GameObject instantiatedPlayer = (GameObject)Network.Instantiate(playerPrefab,playerSpawns[Random.Range(0,playerSpawns.Length)], Quaternion.identity, 10);
		gameManager manager = gameManager.GetComponent<gameManager>();

		//Add the players to the game manager
		if(manager.playerA == null && manager.playerB == null) {
			manager.playerA = instantiatedPlayer;

			networkSync status = instantiatedPlayer.GetComponent<networkSync>();
			status.playerName = "Player A";

		} 
		if(manager.playerA != null && manager.playerB == null) {
			manager.playerB = instantiatedPlayer;

			networkSync status = instantiatedPlayer.GetComponent<networkSync>();
			status.playerName = "Player B";

		}

    }
}
