using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
[RequireComponent(typeof(CharacterController))]
public class playerWalk: MonoBehaviour {
	public AudioClip[] soundOut;
	public AudioClip[] soundWater;
	public AudioClip[] soundMetal;
	private CharacterController _controller;
	
	void Awake() {
	//	_controller = GetComponent<CharacterController>();
	}
	
	// Use this for initialization
	IEnumerator Start () {
		while(true) {
			//float vel = _controller.velocity.magnitude;
			RaycastHit hit = new RaycastHit();
			string floortag;

			if(Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.D)) {
				if(Physics.Raycast(transform.position, Vector3.down,out hit))
				{
					floortag = hit.collider.gameObject.tag;
					if (floortag == "Ground" || floortag == "Untagged")
					{
						audio.clip = soundOut[Random.Range(0,soundOut.Length)];
					}
					else if (floortag == "Water")
					{
						audio.clip = soundWater[Random.Range(0,soundWater.Length)];
					}
					else if (floortag == "Metal")
					{
						audio.clip = soundMetal[Random.Range(0,soundMetal.Length)];
					}
				}
				
				
				audio.pitch = (float)(0.9 + 0.2*Random.value); // randomize pitch in the range 1 +/- 0.1 
				audio.PlayOneShot(audio.clip);
				float interval = audio.clip.length;
				yield return new WaitForSeconds(interval);
			}
			else {
				yield return 0;
			}
		}
		
	}

}