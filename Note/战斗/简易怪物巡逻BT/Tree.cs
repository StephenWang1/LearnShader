using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Tree : MonoBehaviour
{
    public Node root;
    private void Start()
    {
        if (root == null)
        {
            root = SetUp();
        }
    }

    private void Update()
    {
        if (root != null)
        {
            root.Evaluate();
        }
    }

    public abstract Node SetUp();
}
