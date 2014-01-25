using UnityEngine;
using System.Collections;

public class TitleGUIHandler : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

	}

	void OnGUI () {
		// Make the first button. If it is pressed, Application.Loadlevel (1) will be executed
		if (GUI.Button (new Rect ((int)(Screen.width / 2) - 200, 150, 400, 150), "Create Game")) {
			Application.LoadLevel (2);
		}

		if (GUI.Button (new Rect ((int)(Screen.width / 2) - 200, 325, 400, 150), "Join Game")) {
			Application.LoadLevel (2);
		}

		if (GUI.Button (new Rect ((int)(Screen.width / 2) - 100, 500, 200, 100), "Exit")) {
			Application.Quit();
		}
	}
}
