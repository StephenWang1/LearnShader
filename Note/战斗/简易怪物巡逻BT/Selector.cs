using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// 子节点有一个成功则成功
/// </summary>
public class Selector :  Node
{
    public Selector() : base()
    {
      
    }
    public Selector(List<Node> childs) : base(childs)
    {
      
    }

    /// <summary>
    /// 评估函数
    /// </summary>
    /// <returns></returns>
    public override NodeState Evaluate()
    {
        foreach (var child in childs)
        {
            switch (child.Evaluate())
            {
                case NodeState.Fail:
                   continue;
                case NodeState.Running:
                    state = NodeState.Running;
                    return state;
                case NodeState.Success:
                    state = NodeState.Success;
                    return state;
                default:
                    state = NodeState.Running;
                    return state;
            }
        }
        state = NodeState.Fail;
        return state;
    }
}
