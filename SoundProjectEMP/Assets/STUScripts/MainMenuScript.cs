using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenuScript : MonoBehaviour
{
    public GameObject mainMenu;
    public GameObject settingsMenu;

    // Update is called once per frame

    public void PlayGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }

    public void Settings()
    {
        settingsMenu.SetActive(true);
        mainMenu.SetActive(false);
    }

    public void Back()
    {
        settingsMenu.SetActive(false);
        mainMenu.SetActive(true);
    }


    public void ExitGame()
    {

        Debug.Log("Quitting game");
        Application.Quit();
    }

}
