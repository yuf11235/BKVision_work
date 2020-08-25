import numpy as np
import tensorflow as tf
# import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()

def determine_shock(list:'1d list'):
    len_2=len(list)//2
    array1=np.array(list[0:len_2])
    array2=np.array(list[len_2:len_2*2])
    mean1=np.mean(array1)
    mean2=np.mean(array2)
    std1=np.std(array1)
    std2=np.std(array2)
    # print([mean1,mean2,std1,std2])
    if (mean1 - mean2)<std2:
        return True,mean1,mean2,std1,std2
    else:
        return False,mean1,mean2,std1,std2

def optimize_pq(mesh_q: '2d np.array',
                mesh_p:'2d np.array'= None,
                alpha:'[a_errpq, a_l2p, a_l2q]'=[0.8,0.1,0.1],
                auto_alpha = False,
                iterations:int = 100,
                converge:float = 0.01,
                outputfunc = None):
    height = len(mesh_q)
    width = len(mesh_q[0])
    if mesh_p is None:
        mesh_p = np.zeros_like(mesh_q)
    mesh_p_ = np.zeros_like(mesh_q)
    mesh_q_ = np.zeros_like(mesh_q)
    a_errpq = tf.placeholder(dtype=tf.float64,shape=None, name="a_errpq")
    a_l2p = tf.placeholder(dtype=tf.float64,shape=None, name="a_l2p")
    a_l2q = tf.placeholder(dtype=tf.float64,shape=None, name="a_l2q")
    P = tf.constant(mesh_p, name="P")
    Q = tf.constant(mesh_q, name="Q")
    P_ = tf.Variable(P, name="P_")
    Q_ = tf.Variable(Q, name="Q_")
    L2_P =  tf.reduce_mean(tf.pow((P - P_), 2),name="L2_P")
    L2_Q =  tf.reduce_mean(tf.pow((Q - Q_), 2),name="L2_Q")
    P_y = - 0.5 * tf.slice(P_, [0, 0], [height - 1, width - 1]) + 0.5 * tf.slice(P_, [1, 0], [height - 1, width - 1]) \
          - 0.5 * tf.slice(P_, [0, 1], [height - 1, width - 1]) + 0.5 * tf.slice(P_, [1, 1], [height - 1, width - 1])
    Q_x = - 0.5 * tf.slice(Q_, [0, 0], [height - 1, width - 1]) + 0.5 * tf.slice(Q_, [0, 1], [height - 1, width - 1]) \
          - 0.5 * tf.slice(Q_, [1, 0], [height - 1, width - 1]) + 0.5 * tf.slice(Q_, [1, 1], [height - 1, width - 1])
    Err_pq =  tf.reduce_mean(tf.pow((P_y - Q_x), 2),name="Err_pq")
    # Loss = alpha[0]*L2_P + alpha[1]*L2_Q + alpha[2]*Err_pq
    Loss = a_errpq*Err_pq + a_l2p*L2_P + a_l2q*L2_Q
    Sess = tf.Session()
    Optimizer = tf.train.AdamOptimizer(0.1).minimize(Loss)
    Sess.run(tf.global_variables_initializer())
    # mesh_p_, mesh_q_, l2_p, l2_q, err_pq, loss = None
    batch = 200
    num_batch = iterations//batch
    for n in range(num_batch):
        l2_p_list=[]
        l2_q_list=[]
        err_pq_list=[]
        loss_list=[]
        alf_dict = {a_errpq: alpha[0], a_l2p: alpha[1], a_l2q: alpha[2]}
        for b in range(batch):
            _,mesh_p_, mesh_q_ , l2_p, l2_q, err_pq, loss\
                = Sess.run([Optimizer, P_,Q_,Err_pq,L2_P,L2_Q,Loss], alf_dict)
            l2_p_list.append(l2_p)
            l2_q_list.append(l2_q)
            err_pq_list.append(err_pq)
            loss_list.append(loss)
            print('n,l2_p,l2_q,err_pq,loss=',[b+n*batch, alpha[0]*err_pq, alpha[1]*l2_p, alpha[2]*l2_q, loss])
            if outputfunc is not None:
                outputfunc(mesh_p_, mesh_q_)
            if (loss<converge):
                print('Converged')
                break
        l2_p_list_isshock,l2_p_list_mean1,l2_p_list_mean2,l2_p_list_std1,l2_p_list_std2=determine_shock(l2_p_list)
        l2_q_list_isshock,l2_q_list_mean1,l2_q_list_mean2,l2_q_list_std1,l2_q_list_std2=determine_shock(l2_q_list)
        err_pq_list_isshock,err_pq_list_mean1,err_pq_list_mean2,err_pq_list_std1,err_pq_list_std2=determine_shock(err_pq_list)
        loss_list_isshock,loss_list_mean1,loss_list_mean2,loss_list_std1,loss_list_std2=determine_shock(loss_list)
        print('isshock',[l2_p_list_isshock,l2_q_list_isshock,err_pq_list_isshock,loss_list_isshock])
        if loss_list_isshock and auto_alpha:
            if err_pq_list_isshock:
                print('err_pq_list:', [err_pq_list_mean1,err_pq_list_mean2,err_pq_list_std1,err_pq_list_std2])
                alpha[0] = alpha[0]*0.5
                print('a_errpq=',alpha[0])
            if l2_p_list_isshock:
                print('l2_p_list:', [l2_p_list_mean1,l2_p_list_mean2,l2_p_list_std1,l2_p_list_std2])
                alpha[1] = alpha[1]*0.5
                print('a_l2p=',alpha[1])
            if l2_q_list_isshock:
                print('l2_q_list:', [l2_q_list_mean1,l2_q_list_mean2,l2_q_list_std1,l2_q_list_std2])
                alpha[2] = alpha[2]*0.5
                print('a_l2q=',alpha[2])
    Sess.close()
    return mesh_p_, mesh_q_

def optimize_z_if_pq(mesh_q:'2d np.array',
                     mesh_p:'2d np.array'= None,
                     step:'[step_x, step_y]'=[1.00,1.00],
                     alpha:'[a_zxp, a_zyq]'=[0.48,0.48],
                     beta:'[b_zx, b_zy]'=[0.01,0.01],
                     gama:'[g_zxx, g_zyy]'=[0.01,0.01],
                     iterations:int = 100,
                     converge:float = 0.01,
                     outputfunc = None):
    height = len(mesh_q)
    width = len(mesh_q[0])
    if mesh_p is None:
        mesh_p = np.zeros_like(mesh_q)

    P = tf.constant(mesh_p, name="P")
    Q = tf.constant(mesh_q, name="Q")
    Z = tf.Variable(tf.zeros([height,width], dtype= tf.float64), name="Z")
    Zy = - (1/step[0])* tf.slice(Z, [0, 0], [height - 1, width]) + (1/step[0])* tf.slice(Z, [1, 0], [height - 1, width])
    Zx = - (1/step[1])* tf.slice(Z, [0, 0], [height, width - 1]) + (1/step[1])* tf.slice(Z, [0, 1], [height, width - 1])
    Q_ = 0.5*tf.slice(Q, [0, 0], [height - 1, width]) + 0.5*tf.slice(Q, [1, 0], [height - 1, width])
    P_ = 0.5*tf.slice(P, [0, 0], [height, width - 1]) + 0.5*tf.slice(P, [0, 1], [height, width - 1])
    Zyy = tf.slice(Z, [0, 0], [height - 2, width]) - 2*tf.slice(Z, [1, 0], [height - 2, width]) + tf.slice(Z, [2, 0], [height - 2, width])
    Zxy = 0.5 * tf.slice(Z, [0, 0], [height - 1, width - 1]) - 0.5 * tf.slice(Z, [0, 1], [height - 1, width - 1]) \
        - 0.5 * tf.slice(Z, [1, 0], [height - 1, width - 1]) + 0.5 * tf.slice(Z, [1, 1], [height - 1, width - 1])
    Zxx = tf.slice(Z, [0, 0], [height, width - 2]) - 2*tf.slice(Z, [0, 1], [height, width - 2]) + tf.slice(Z, [0, 2], [height, width - 2])
    Err_q =  tf.reduce_mean(tf.pow((Zy - Q_), 2),name="Err_q")
    Err_p =  tf.reduce_mean(tf.pow((Zx - P_), 2),name="Err_p")
    L2_Zy =  tf.reduce_mean(tf.pow((Zy), 2),name="L2_Zy")
    L2_Zx =  tf.reduce_mean(tf.pow((Zx), 2),name="L2_Zx")
    L2_Zyy =  tf.reduce_mean(tf.pow((Zyy), 2),name="L2_Zyy")
    L2_Zxy =  tf.reduce_mean(tf.pow((Zxy), 2),name="L2_Zxy")
    L2_Zxx =  tf.reduce_mean(tf.pow((Zxx), 2),name="L2_Zxx")
    # Loss = alpha[0]*L2_P + alpha[1]*L2_Q + alpha[2]*Err_pq
    Loss = alpha[0]*Err_p + alpha[1]*Err_q + beta[0]*L2_Zx + beta[1]*L2_Zy\
           + gama[0] * gama[0] * L2_Zxx + 2* gama[0] * gama[1] * L2_Zxy + gama[1] * gama[1] * L2_Zyy
    Sess = tf.Session()
    Optimizer = tf.train.AdamOptimizer(0.1).minimize(Loss)
    Sess.run(tf.global_variables_initializer())
    # mesh_p_, mesh_q_, l2_p, l2_q, err_pq, loss = None
    batch = 200
    num_batch = iterations//batch
    for n in range(iterations):
        _,mesh_z_, mesh_p_, mesh_q_ , err_p, err_q, l2_zx, l2_zy, l2_zxx, l2_zxy, l2_zyy, loss\
            = Sess.run([Optimizer, Z, Zx, Zy, Err_p, Err_q, L2_Zx, L2_Zy, L2_Zxx , L2_Zxy , L2_Zyy , Loss])
        print('n,err_p, err_q, l2_zy, l2_zx, l2_zxx, l2_zxy, l2_zyy, loss=',
              [n, alpha[0]*err_p, alpha[1]*err_q, beta[0]*l2_zx, beta[1]*l2_zy,
               gama[0] * gama[0] * l2_zxx, 2* gama[0] * gama[1] * l2_zxy, gama[1] * gama[1] * l2_zyy, loss])
        if outputfunc is not None:
            outputfunc(mesh_z_)
        #outputfunc(0.5*(mesh_p_[0:39,:]+mesh_p_[1:40,:]), 0.5*(mesh_q_[:,0:39]+mesh_q_[:,1:40]))
        if (loss<converge):
            print('Converged')
            break
    Sess.close()
    return mesh_z_, mesh_p_, mesh_q_
