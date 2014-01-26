using UnityEngine;
using System.Collections;

public class gameManager : MonoBehaviour {

	public int range;

	public GameObject playerA;
	public GameObject playerB;

	//PLAYER SCORE
	public int scoreLimit;
	public int playerAScore;
	public int playerBScore;

	int stalkStatus;
	int stalkStatusTemp;

	// Use this for initialization
	void Start () {
		stalkStatusTemp = 0;
		playerAScore = 0;
		playerBScore = 0;
	}
	
	// Update is called once per frame
	void Update () {
		//Update the fog of war


		//Start the random game state thingy.
		StartCoroutine(rand());

		networkSync scriptA = playerA.GetComponent<networkSync>();
		networkSync scriptB = playerA.GetComponent<networkSync>();

		/*if (Network.isClient) {
			UnityEngine.Debug.Log ("CLIENT");
			if(stalkStatus == 1) {
				scriptA.state = networkSync.playerStates.Avoid;
				scriptB.state = networkSync.playerStates.Follow;
			} else {
				scriptA.state = networkSync.playerStates.Follow;
				scriptB.state = networkSync.playerStates.Avoid;
			}
		}*/
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
