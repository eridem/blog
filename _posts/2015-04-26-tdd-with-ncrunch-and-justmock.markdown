---
layout:     post
title:      "TDD with NCrunch and JustMock"
description: "Continuous Testing"
author:     "eridem"
main-img: "img/featured/2015-04-26-tdd-with-ncrunch-and-justmock.jpg"
permalink:  tdd-with-ncrunch-and-justmock
---

Just an example.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using Telerik.JustMock;
using Assert = Microsoft.VisualStudio.TestTools.UnitTesting.Assert;

namespace TDD
{
    [TestFixture]
    public class UnitTest1
    {
        [Test]
        public void CalculatorShouldInitWithZero()
        {
            var numberParserMock = Mock.Create<LocalNumberParser>(Behavior.CallOriginal);
            var sumOperation = Mock.Create<Sum>(Behavior.CallOriginal);
            StringCalculator sCalculator = new StringCalculator(numberParserMock, sumOperation);
            Assert.AreEqual(0, sCalculator.Total, "Init total should be zero");
        }

        [Test]
        [TestCase("1,3", new []{1,3}, 4)]
        [TestCase("2,4", new[] { 2, 4 }, 6)]
        [TestCase("10,1", new[] { 10, 1 }, 11)]
        [TestCase("0,0", new[] { 0, 0 }, 0)]
        [TestCase("9837, 1278", new[] { 9837, 1278 }, 9837 + 1278)]
        public void CalculatorShouldSumTwoNumbers(String sumValues, IEnumerable<int> parserExpected, int expected)
        {
            var numberParserMock = Mock.Create<INumberParser>();
            var sumOperation = Mock.Create<IOperation>();
            
            Mock.Arrange(() => numberParserMock.Parse(Arg.AnyString)).Returns(parserExpected);
            Mock.Arrange(() => sumOperation.GetResult(parserExpected)).Returns(expected);
            
            StringCalculator sCalculator = new StringCalculator(numberParserMock, sumOperation);

            sCalculator.Sum(sumValues);

            Assert.AreEqual(expected, sCalculator.Total, "Calculator did not sum well with two values: " + sumValues + " and result: " + sCalculator.Total);
        }
    }

    public class StringCalculator
    {
        public int Total { get; set; }

        private IOperation SumOperation;

        public StringCalculator(INumberParser numberParser, IOperation sumOperation)
        {
            NumberParser = numberParser;
            SumOperation = sumOperation;
        }

        public void Sum(string values)
        {
            IEnumerable<int> numbers = GetNumbers(values);
            Total += SumOperation.GetResult(numbers);
        }

        private static IEnumerable<int> GetNumbers(string values)
        {
            return NumberParser.Parse(values);
        }

        public static INumberParser NumberParser { get; set; }
    }

    public interface IOperation
    {
        int GetResult(IEnumerable<int> numbers);
    }

    public class Sum : IOperation
    {
       public int GetResult(IEnumerable<int> numbers)
        {
            return numbers.Sum();
        }
    }

    public interface INumberParser
    {
        IEnumerable<int> Parse(String numbers);
    }

    public class LocalNumberParser : INumberParser
    {
        public IEnumerable<int> Parse(string numbers)
        {
            string[] nums = numbers.Split(',');
            return nums.Select(int.Parse);
        }
    }
}
```
