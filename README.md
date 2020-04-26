# sosl_flow_component

This is a basic SOSL apex invokable class, made primarily for use in flows. It was developed for use with [DatatableFSC](https://unofficialsf.com/datatable/), but can be used in any flow where a collection should be returned from a search. The benefit of using this approach is that you take advantage of Salesforce's fuzzy logic in search, where you can miss leading or trailing letters, or use close names, e.g. a search for Davi or Dave will return David.

## Getting Started

You can install the package from these links:

[Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2w000004kaeW)

[Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t2w000004kaeW)

## What It Does

The invokable class takes a set of variable, and returns a collection of records found during the search.

First, collect the queries. You can use a single query, or a list. In the example below, I'm looking for contacts with a name, email or phone number.

![Query Collection](https://i.imgur.com/Fvfsk8w.png)

If you're using more than one query, you'll need to add them to a list. This is done by setting up a text type collection variable:

![Variable](https://i.imgur.com/3eQgBwh.png)

Then you need to assign each query to that list. In the example below I'm checking whether the query had a value before I add it, so I don't add an empty string:

![Flow](https://i.imgur.com/Gcq6lwQ.png)

![Assignment](https://i.imgur.com/27jn1q1.png)

Then I pass that list into the invokable action, along with the SObject type, and a [scope](https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_sosl_in.htm#topic-title) or where clause if required. The process returns a list of ID's, which I store in another text collection variable:

![Invokation](https://i.imgur.com/5pED7Rz.png)

If I need more than the ID, I iterate through the results, adding the records to a record collection variable:

![RecordLoop](https://i.imgur.com/mKDYrTl.png)

Then I present it in a datatable, following the instructions in the [DatatableFSC](https://unofficialsf.com/datatable/) documentation.

![result](https://i.imgur.com/xVpTWfP.png)

From there, I can select a record, edit inline, or take other actions.



## License

This project is licensed under the GNU GPLv3 License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Eric Smith - [website](https://ericsplayground.wordpress.com/author/ericsplayground/)
* [UnofficialSF.com](https://unofficialsf.com/) 
* [GravityLab](gravitylab.nz) 
