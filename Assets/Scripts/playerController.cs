using UnityEngine;
using System.Collections;

public class playerController : MonoBehaviour {

	// --- PLAYER VARIABLES ---
	public Vector3 playerPos;
	public bool playerInRange;
	public enum playerStates{Search, Avoid, Follow, Caught};
	public bool playerDeath;
	public playerStates state = playerStates.Search;

	// --- ENEMY VARIABLES ---
	public string enemy;
	public Vector3 enemyPos;

	void Start() {
		playerInRange = false;
		state = playerStates.Search;
	}

	void Update () {
		//Keep tabs on the players locations and distance from each other.
		playerPos = this.transform.position;
		enemyPos = FindClosestEnemy().transform.position;
		var distance = Vector3.Distance(this.transform.position, FindClosestEnemy().transform.position);

		//Determine if player is close to the enemy. If so change state. We'll alert them later.
		if (distance < 10.0f) {
			playerInRange = true;
			//TODO: GUI - Show on screen the players state.
			//print(state);
		} else {
			playerInRange = false;
		}
	}

	//Handy little function to help us find the closest enemy. With that done we can pull information regarding them.
	GameObject FindClosestEnemy() {
		GameObject[] gos;
		gos = GameObject.FindGameObjectsWithTag("Enemy");
		GameObject closest = null;
		float distance = Mathf.Infinity;
		Vector3 position = transform.position;
		foreach (GameObject go in gos) {
			Vector3 diff = go.transform.position - position;
			float curDistance = diff.sqrMagnitude;
			if (curDistance < distance) {
				closest = go;
				distance = curDistance;
			}
		}
		return closest;
	}

	//Tag: Determine results when a player tags another
	void OnTriggerEnter(Collider other) {
		if(other.gameObject.CompareTag("Enemy")) {
			print("YOLO");
			state = playerStates.Caught;
			playerDeath = true;
		}
	}

}
