using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestTree : Tree
{
    public static float MoveSpeed = 3;
    //寻到目标点的停留时间
    public static float PatrolCD = 1;
    public Transform goTrans;
    public Transform[] ways;
    public override Node SetUp()
    {
        var node = new TaskPatrol(goTrans, ways);
        return node;
    }
}
