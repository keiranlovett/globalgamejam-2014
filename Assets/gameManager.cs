using UnityEngine;
using System.Collections;

public class gameManager : MonoBehaviour {


	bool isLeader; 
	public bool fogOfWar;
	public bool firstPerson;
	public Transform FogOfWarPlane;
	public GameObject localplayerPos;

	float t;
	public int range;

//	public scriptA a;
//	public scriptB b;

	public GameObject playerA;
	public GameObject playerB;
	int playerAScore;
	int playerBScore;

	int stalkStatus;
	int stalkStatusTemp;
	public bool stalkAssign;

	// Use this for initialization
	void Start () {
		//If leader - determines game states.
		isLeader = true;

		//Set Game mode to first person perspective
		if(firstPerson == true) {
			localplayerPos.GetComponent<MouseLook>().enabled = true;
			localplayerPos.transform.Find("Main Camera").GetComponent<MouseLook>().enabled = true;
			localplayerPos.transform.Find("Main Camera").transform.localPosition = new Vector3(0,0,0);
		}

		//Set up 

	}
	
	// Update is called once per frame
	void Update () {
		//Update the fog of war
		if(fogOfWar == true) {
			FogOfWarPlane.GetComponent<Renderer>().material.SetVector("_Player1_Pos", localplayerPos.transform.position);
		} else {
			FogOfWarPlane.active = false;
		}

		//Start the random game state thingy.
		StartCoroutine(rand());

		playerController scriptA = playerA.GetComponent<playerController>();
		playerController scriptB = playerA.GetComponent<playerController>();

		if(stalkStatus == 1) {
			scriptA.state = playerController.playerStates.Avoid;
			scriptB.state = playerController.playerStates.Follow;
		} else {
			scriptA.state = playerController.playerStates.Follow;
			scriptB.state = playerController.playerStates.Avoid;
		}

	}

	//Determine stalk status randomly. Update variables accordingly.
	IEnumerator  rand (){
		int rand = Random.Range(0,100);
		
		stalkStatusTemp = stalkStatus;
		
		if(rand > range) {
			stalkStatus = Random.Range(0,2);
		}
		
		yield return new WaitForSeconds(t);
	}

}
