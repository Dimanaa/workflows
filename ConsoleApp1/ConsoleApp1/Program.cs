using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleCalculator
{
    class Program
    {
        static void Main(string[] args)
        {
            double num1, num2, sum;

            Console.WriteLine("Simple Calculator");
            Console.WriteLine("Enter the first number: ");
            num1 = Convert.ToDouble(Console.ReadLine());

            Console.WriteLine("Enter the second number: ");
            num2 = Convert.ToDouble(Console.ReadLine());

            sum = num1 + num2;

            Console.WriteLine("The sum of {0} and {1} is: {2}", num1, num2, sum);

            Console.ReadLine(); // This line is added to keep the console window open.
        }
    }
}
