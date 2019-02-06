using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

public class MixerScript : MonoBehaviour
{

    public AudioMixer audioMix;
    public AudioMixerSnapshot snap100;
    public AudioMixerSnapshot snap50;
    public AudioClip buttonClick;

    public Slider volumeSlider;

    //bool bPause = false;

    // Start is called before the first frame update
    void Start()
    {
        SetVolume();
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void Pause()
    {
        //bPause = !bPause;
        if (PauseMenuScript.GameIsPaused)
        {
            snap50.TransitionTo(0.5f);
        }
        else
        {
            snap100.TransitionTo(0.5f);
        }
    }

    public void SetVolume()
    {
        audioMix.SetFloat("MasterVolume", volumeSlider.value);
    }

    public void ButtonHighlighted(int track)
    {
        if (track == 1)
        {
            
            Debug.Log("Play button highlighted");
        }
    }
}
