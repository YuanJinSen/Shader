using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ProcediralTextureGeneration : MonoBehaviour
{
    public Material mat = null;

    #region 0
    [SerializeField, SetProperty("textureWidth")]
    private int m_textureWidth = 512;
    public int textureWidth
    {
        get
        {
            return m_textureWidth;
        }
        set
        {
            m_textureWidth = value;
            _UpdataMaterial();
        }
    }

    [SerializeField, SetProperty("backgroundColor")]
    private Color m_backgroundColor = Color.white;
    public Color backgroundColor
    {
        get
        {
            return m_backgroundColor;
        }
        set
        {
            m_backgroundColor = value;
            _UpdataMaterial();
        }
    }

    [SerializeField, SetProperty("circleColor")]
    private Color m_circleColor = Color.yellow;
    public Color circleColor
    {
        get
        {
            return m_circleColor;
        }
        set
        {
            m_circleColor = value;
            _UpdataMaterial();
        }
    }

    [SerializeField, SetProperty("blurFactor")]
    private float m_blurFactor = 2f;
    public float blurFactor
    {
        get
        {
            return m_blurFactor;
        }
        set
        {
            m_blurFactor = value;
            _UpdataMaterial();
        }
    }
    #endregion

    private Texture2D m_generatedTexture = null;

    private void Start()
    {
        if(!mat)
        {
            Renderer renderer = gameObject.GetComponent<Renderer>();
            if (!renderer) return;
            mat = renderer.sharedMaterial;
        }
        _UpdataMaterial();
    }


    private void _UpdataMaterial()
    {
        if (mat)
        {
            m_generatedTexture = _GenerateProceduralTexture();
            mat.SetTexture("_MainTex", m_generatedTexture);
        }
    }

    private Texture2D _GenerateProceduralTexture()
    {
        Texture2D tex = new Texture2D(textureWidth, textureWidth);

        float circleInterval = textureWidth / 4f;
        float radius = textureWidth / 10f;
        float edgeBlur = 1f / blurFactor;

        for (int w = 0; w < textureWidth; w++)
        {
            for (int h = 0; h < textureWidth; h++)
            {
                Color pixel = backgroundColor;
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        Vector2 circleCenter = new Vector2(circleInterval * (i + 1), circleInterval * (j + 1));
                        float dis = Vector2.Distance(new Vector2(w, h), circleCenter) - radius;
                        if (dis > 0) pixel = circleColor;
                        //Color color = _MixColor(circleColor, new Color(pixel.r, pixel.g, pixel.b, 0), Mathf.SmoothStep(0, 1, dis * edgeBlur));
                        //pixel = _MixColor(pixel, color, color.a);
                    }
                }
                tex.SetPixel(w, h, pixel);
            }
        }
        tex.Apply();
        return tex;
    }

    private Color _MixColor(Color color0, Color color1, float mixFactor)
    {
        Color mixColor = Color.white;
        mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
        mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
        mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
        mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
        return mixColor;
    }
}
