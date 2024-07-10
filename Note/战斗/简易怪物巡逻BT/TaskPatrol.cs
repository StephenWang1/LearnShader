using UnityEngine;
/// <summary>
/// 任务巡逻
/// </summary>
public class TaskPatrol : Node
{
    private Transform _goTrans;
    private Transform[] _ways;
    private int _currWayIndex = 0;
    private float _cdCountDown;
    private Material _material;
    public TaskPatrol(Transform goTrans, Transform[] ways)
    {
        _goTrans = goTrans;
        _ways = ways;
        _material = goTrans.GetComponent<MeshRenderer>().sharedMaterial;
    }

    public override NodeState Evaluate()
    {
        //在抵达寻路点等待CD
        if (_cdCountDown > 0)
        {
            _cdCountDown -= Time.deltaTime;
            if (_material != null)
            {
                _material.color = Color.yellow;
            }
            return NodeState.Success;
        }
        
        if (_material != null)
        {
            _material.color = Color.red;
        }
        var targetTrans = _ways[_currWayIndex];
        
        var dis = Vector3.Distance(_goTrans.position, targetTrans.position);
        if (dis < 0.1f)
        {
            _currWayIndex = (_currWayIndex + 1) % _ways.Length;
            state = NodeState.Success;
            //在抵达寻路点进入CD
            _cdCountDown = TestTree.PatrolCD;
        }
        else
        {
            _goTrans.position = Vector3.MoveTowards(_goTrans.position, targetTrans.position,
                TestTree.MoveSpeed * Time.deltaTime);
            _goTrans.LookAt(targetTrans);
        }
        state = NodeState.Running;
        return state;
    }
}
