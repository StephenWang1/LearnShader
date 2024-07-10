using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// 子节点全部成功，才返回成功
/// </summary>
public class Sequence : Node
{
   public Sequence() : base()
   {
      
   }
   public Sequence(List<Node> childs) : base(childs)
   {
      
   }

   public override NodeState Evaluate()
   {
      bool isAnyChildRun = false;
      foreach (var child in childs)
      {
         switch (child.Evaluate())
         {
            case NodeState.Fail:
               state = NodeState.Fail;
               return state;
            case NodeState.Running:
               isAnyChildRun = true;
               continue;
            case NodeState.Success:
               continue;
            default:
               isAnyChildRun = true;
               continue;
         }
      }

      state = isAnyChildRun ? NodeState.Running : NodeState.Success;
      return state;
   }
}
