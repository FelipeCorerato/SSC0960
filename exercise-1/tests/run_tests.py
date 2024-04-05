import os
import subprocess

def compare_outputs(output_data, expected_output_data):
    return output_data.strip() == expected_output_data.strip()

def run_test_case(program_path, input_file, expected_output_file):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_path = os.path.join(script_dir, 'cases', input_file)
    output_path = os.path.join(script_dir, 'outputs', f"{input_file.split('.')[0]}.out")
    expected_output_path = os.path.join(script_dir, 'cases', expected_output_file)

    subprocess.run(['python3', program_path], stdin=open(input_path, 'r'), stdout=open(output_path, 'w'))

    with open(output_path, 'r') as output_file, open(expected_output_path, 'r') as expected_output_file:
        output_data = output_file.read()
        expected_output_data = expected_output_file.read()
        print(f"Running test case {input_file}")
        if compare_outputs(output_data, expected_output_data):
            print(" ✅ Test succeed!\n")
            return True
        else:
            print(" ❌ Test failed!\n")
            return False

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    program_path = os.path.join(script_dir, '..', 'exercise.py')
    test_cases_dir = os.path.join(script_dir, 'cases')
    output_dir = os.path.join(script_dir, 'outputs')
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    test_cases = sorted([file for file in os.listdir(test_cases_dir) if file.endswith('.in')])
    passed_tests = 0
    failed_tests = []
    
    for input_file in test_cases:
        expected_output_file = f"{input_file.split('.')[0]}.out"
        if run_test_case(program_path, input_file, expected_output_file):
            passed_tests += 1
        else:
            failed_tests.append(input_file)

    print("\nFinal results:")
    if len(failed_tests) == 0:
        print("All tests are passing! ✅")
    else:
        print("Failed cases:")
        for test in failed_tests:
            print(f"- {test}")
