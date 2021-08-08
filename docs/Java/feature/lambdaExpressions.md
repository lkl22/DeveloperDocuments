# Lambda Expressions

* [参考文献](#参考文献)

匿名类的一个问题是，如果匿名类的实现非常简单，例如只包含一个方法的接口，那么匿名类的语法可能会显得笨拙和不简洁。 在这些情况下，您通常会尝试将功能作为参数传递给另一个方法，例如当有人单击按钮时应该采取什么操作。 Lambda 表达式使您能够做到这一点，将功能视为方法参数，或将代码视为数据。

[匿名类](https://docs.oracle.com/javase/tutorial/java/javaOO/anonymousclasses.html)，向您展示了如何在不为其命名的情况下实现基类。 虽然这往往比命名类更简洁，但对于只有一个方法的类来说，即使是匿名类也显得有些过多和繁琐。 `Lambda` 表达式让您可以更紧凑地表达单一方法类的实例。

* [Lambda 表达式的理想用例](#IdealUseCaseforLambdaExpressions)
  * Approach 1: Create Methods That Search for Members That Match One Characteristic
  * Approach 2: Create More Generalized Search Methods
  * Approach 3: Specify Search Criteria Code in a Local Class
  * Approach 4: Specify Search Criteria Code in an Anonymous Class
  * Approach 5: Specify Search Criteria Code with a Lambda Expression
  * Approach 6: Use Standard Functional Interfaces with Lambda Expressions
  * Approach 7: Use Lambda Expressions Throughout Your Application
  * Approach 8: Use Generics More Extensively
  * Approach 9: Use Aggregate Operations That Accept Lambda Expressions as Parameters
* Lambda Expressions in GUI Applications
* Syntax of Lambda Expressions
* Accessing Local Variables of the Enclosing Scope
* Target Typing
  * Target Types and Method Arguments
* Serialization
* [参考文献](#参考文献)

## <a name="IdealUseCaseforLambdaExpressions">Lambda 表达式的理想用例</a>

假设您正在创建一个社交网络应用程序。 您想要创建一个功能，使管理员能够对满足特定条件的社交网络应用程序的成员执行任何类型的操作，例如发送消息。 下表详细描述了此用例：

Field	|Description
---|---
Name	| 对选定成员执行操作
Primary Actor	| Administrator
先决条件(Preconditions)	|管理员已登录系统
后置条件(Postconditions)	|仅对符合指定条件的成员执行操作
主要成功场景(Main Success Scenario)	|1. 管理员指定执行特定操作的成员标准。<br/>2. 管理员指定要对这些选定成员执行的操作。<br/>3. 管理员选择提交按钮。<br/>4. 系统将查找与指定条件匹配的所有成员。<br/>5. 系统对所有匹配的成员执行指定的操作。<br/>
扩展(Extensions)	|1a. 管理员可以选择在他或她指定要执行的操作之前或在选择提交按钮之前预览那些符合指定条件的成员。
发生频率(Frequency of Occurrence)	| Many times during the day.

假设此社交网络应用程序的成员由以下 `Person` 类表示：

```java
public class Person {

    public enum Sex {
        MALE, FEMALE
    }

    String name;
    LocalDate birthday;
    Sex gender;
    String emailAddress;

    public int getAge() {
        // ...
    }

    public void printPerson() {
        // ...
    }
}
```

假设您的社交网络应用程序的成员存储在 `List<Person>` 实例中。

本节以针对此用例的一种天真的方法开始。它使用本地和匿名类改进了这种方法，然后使用 `lambda` 表达式以一种高效而简洁的方法结束。 

## <a name="参考文献">参考文献</a>

[https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

