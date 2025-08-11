#!/bin/bash                                                                                                    

#! sbatch directives begin here ###############################                                                    
#! Name of the job:                                                                                                
#SBATCH -J liftOver
#SBATCH -A FERGUSON-SMITH-SL2-CPU 
#SBATCH --nodes=1                                                                                                  
#SBATCH --ntasks=15                                                                                                
#SBATCH --time=12:00:00                                                                                            
#SBATCH --mail-type=NONE                                                                                      

#SBATCH -p cclake

#! ############################################################                                                    



#! Optionally modify the environment seen by the application                                                       

. /etc/profile.d/modules.sh                # Leave this line (enables the module command)                          

module purge                               # Removes all modules still loaded                                      
module load rhel7/default-ccl
module load bcftools-1.9-gcc-5.4.0-b2hdt5n

### change this to point to the script you want to run ##

application="bash minimap_and_syri.sh $1 $2"






################################################################
### don't change anything after this 

#! Number of nodes and tasks per node allocated by SLURM (do not change):

numnodes=$SLURM_JOB_NUM_NODES
numtasks=$SLURM_NTASKS
mpi_tasks_per_node=$(echo "$SLURM_TASKS_PER_NODE" | sed -e  's/^\([0-9][0-9]*\).*$/\1/')
 

#! Work directory (i.e. where the job will run):                                                                   

workdir="$SLURM_SUBMIT_DIR"  # The value of SLURM_SUBMIT_DIR sets workdir to the directory                         

                             # in which sbatch is run.                                                             

 

export OMP_NUM_THREADS=1

np=$[${numnodes}*${mpi_tasks_per_node}]

export I_MPI_PIN_DOMAIN=omp:compact # Domains are $OMP_NUM_THREADS cores in size                                   

export I_MPI_PIN_ORDER=scatter # Adjacent domains have minimal sharing of caches/sockets                           

CMD="$application"

###############################################################                                                    

### You should not have to change anything below this line ####                                                    

###############################################################                                                    

 

cd $workdir

echo -e "Changed directory to `pwd`.\n"

 

JOBID=$SLURM_JOB_ID

 

echo -e "JobID: $JOBID\n======"

echo "Time: `date`"

echo "Running on master node: `hostname`"

echo "Current directory: `pwd`"

 

if [ "$SLURM_JOB_NODELIST" ]; then

        #! Create a machine file:                                                                                  

        export NODEFILE=`generate_pbs_nodefile`

        cat $NODEFILE | uniq > machine.file.$JOBID

        echo -e "\nNodes allocated:\n================"

        echo `cat machine.file.$JOBID | sed -e 's/\..*$//g'`

fi

 

echo -e "\nnumtasks=$numtasks, numnodes=$numnodes, mpi_tasks_per_node=$mpi_tasks_per_node (OMP_NUM_THREADS=$OMP_NU\

M_THREADS)"

 

echo -e "\nExecuting command:\n==================\n$CMD\n"

 

eval $CMD
