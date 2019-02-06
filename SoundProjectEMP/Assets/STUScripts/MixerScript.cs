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

    public Slider volumeSlider;

    bool bPause = false;

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
        bPause = !bPause;
        if (bPause)
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
}
