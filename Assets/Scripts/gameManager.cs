using UnityEngine;
using System.Collections;

public class gameManager : MonoBehaviour {

	bool isLeader; 
	public bool fogOfWar;
	public bool firstPerson;
	public Transform FogOfWarPlane;
	public GameObject localplayerPos;
	public Transform[] playerSpawns;
	public bool roundSet;
	
	//Random Counter 
	public int range;

	public GameObject playerA;
	public GameObject playerB;
	public int scoreLimit;
	public int playerAScore;
	public int playerBScore;


	int stalkStatus;
	int stalkStatusTemp;

	// Use this for initialization
	void Start () {
		//If leader - determines game states. TODO fix
		isLeader = true;
		stalkStatusTemp = 0;
		//Set Game mode to first person perspective
		if(firstPerson == true) {
			localplayerPos.GetComponent<MouseLook>().enabled = true;
			localplayerPos.transform.Find("Main Camera").GetComponent<MouseLook>().enabled = true;
			localplayerPos.transform.Find("Main Camera").transform.localPosition = new Vector3(0,0,0);
		}
		roundSet = false;
		playerAScore = 0;
		playerBScore = 0;
	}
	
	// Update is called once per frame
	void Update () {
		//Update the fog of war
		if(fogOfWar == true) {
			FogOfWarPlane.GetComponent<Renderer>().material.SetVector("_Player1_Pos", localplayerPos.transform.position);

			//Fog for other player.
			/*if(localplayerPos == playerA) {
				FogOfWarPlane.GetComponent<Renderer>().material.SetVector("_Player1_Pos", playerA.transform.position);
			} else {
				FogOfWarPlane.GetComponent<Renderer>().material.SetVector("_Player1_Pos", playerB.transform.position);
			}*/
		} else {
			FogOfWarPlane.gameObject.active = false;
		}

		//Start the random game state thingy.
		StartCoroutine(rand());

		playerController scriptA = playerA.GetComponent<playerController>();
		playerController scriptB = playerA.GetComponent<playerController>();

		if(isLeader == true) {
			if(stalkStatus == 1) {
				scriptA.state = playerController.playerStates.Avoid;
				scriptB.state = playerController.playerStates.Follow;
			} else {
				scriptA.state = playerController.playerStates.Follow;
				scriptB.state = playerController.playerStates.Avoid;
			}
		}

		if(scriptA.playerDeath == true) {
			playerBScore ++;
		} 
		if(scriptB.playerDeath == true) {
			playerAScore ++;
		} 

		if(playerBScore == scoreLimit || playerBScore == scoreLimit) {
			//TODO End Game UI 
		}
		//if(

		if(roundSet == false) {
			if(isLeader == true) {
				playerA.transform.position = playerSpawns[Random.Range(0,playerSpawns.Length)].transform.localPosition;
				playerB.transform.position = playerSpawns[Random.Range(0,playerSpawns.Length)].transform.localPosition;
				if(playerB.transform.position == playerA.transform.position) {
					playerB.transform.position = playerSpawns[Random.Range(0,playerSpawns.Length)].transform.localPosition;
				}
				if(playerB.transform.position != playerA.transform.position) {
					roundSet = true;
				}
			}
		}
	}

	//Determine stalk status randomly. Update variables accordingly.
	IEnumerator  rand (){
		int rand = Random.Range(0,100);
		
		stalkStatusTemp = stalkStatus;
		
		if(rand > range) {
			stalkStatus = Random.Range(0,2);
		}
		yield return new WaitForSeconds(0);
	}

}
