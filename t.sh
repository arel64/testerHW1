function run_valgrind_command() {
  local exitcodeGood=$1
  local valgrind_command=$2
  # Run the valgrind command with the --error-exitcode option
  temp=$(eval "$valgrind_command")
  # Check the exit code of the valgrind command
  if [ $? -eq $exitcodeGood ]; then
    echo -n "Test Success "
	eval "grep -oP '(?<=log-file=logs/)[^ ]*' <<< '$valgrind_command'"
  else
	echo "Test Fail(Mem Leak or unexpected error code), for parmeters"
    eval "grep -oP '(?<=kmeans ).*$' <<< '$valgrind_command'"  
  fi

}

rm -f kmeans
eval "gcc -ansi -Wall -Wextra -Werror -pedantic-errors kmeans.c -o kmeans -lm"
if [ $? -ne 0 ]; then
	echo "Compilaton Failed, Run script in the same directory as kmeans.c"
	exit 1
fi
rm -rf logs
mkdir -p logs
valgrind_bad_commands=(
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterLow1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 0 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterHigh1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterWithIter1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 100000 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterWithValidIter1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 100 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIter1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 0 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIterHigh1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 1000 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIterHighNonNum1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 1a0 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterNonNum1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 1a0 10 <input/input_1.txt"
	
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterLow2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 0 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterHigh2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterWithIter2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 100000 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterWithValidIter2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 100000 100 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIter2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 0 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIterHigh2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 1000 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidIterHighNonNum2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 10 1a0 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/InvalidClusterNonNum2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 1a0 10 <input/input_2.txt"
)
valgrind_good_commands=(
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/Valid1.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 3 100 <input/input_1.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/Valid2.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 7 <input/input_2.txt"
	"valgrind --leak-check=full --show-reachable=yes --log-file=logs/Valid3.txt --track-origins=yes --error-exitcode=2 --errors-for-leak-kinds=all ./kmeans 15 300 <input/input_3.txt"
)

#memory test
for valgrind_command in "${valgrind_bad_commands[@]}";
do
	run_valgrind_command 1 "$valgrind_command"
done
for valgrind_command in "${valgrind_good_commands[@]}";
do
	run_valgrind_command 0 "$valgrind_command"
done
#good output test
test_output=(
	"./kmeans 3 100 <input/input_1.txt"
	"./kmeans 7 <input/input_2.txt"
	"./kmeans 15 300 <input/input_3.txt"
)
for i in "${!test_output[@]}";
do
	j=$(( i+1 ))
	echo "$(eval "${test_output[$i]}")" >> file.txt
	diff_output=$(diff output/output_$j.txt file.txt)
	if [ -z "$diff_output" ]; then
		echo "Good Output $j"
	else
		echo "Input number $j wrong"
	fi
	rm file.txt
done
exit 0


