using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum NodeState
{
    Running,
    Success,
    Fail
}
public class Node
{
    public Node parent;
    public NodeState state;
    public List<Node> childs = new List<Node>();
    public Dictionary<string, object> dataDic = new Dictionary<string, object>();
    public Node()
    {
        parent = null;
    }

    public Node(List<Node> childs)
    {
        foreach (var child in childs)
        {
            Attach(child);
        }
    }

    public void Attach(Node child)
    {
        child.parent = this;
        childs.Add(child);
    }

    public void SetData(string key, object data)
    {
        dataDic[key] = data;
    }

    public object GetData(string key)
    {
        if (dataDic.TryGetValue(key,out var t))
        {
            return t;
        }
        return null;
    }
    
    public void ClearData(string key)
    {
        if (dataDic.TryGetValue(key,out var t))
        {
            dataDic[key] = null;
        }
    }

    public virtual NodeState Evaluate() => NodeState.Fail;
}
