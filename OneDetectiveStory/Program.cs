using Newtonsoft.Json.Linq;
using Microsoft.Dynamics.Nav.Runtime;
using Microsoft.Dynamics.Nav.Types;
using Newtonsoft.Json;

writeMultilineNavTextToConsole();
jsonObjectInitializedFromString();
navJonObjectInitializedFromNavText();
navJsonObjectInitializedByReadFrom();
jTokenInitializedByReadFrom();
implicitConversionNavTextToNavJsonToken();

void writeMultilineNavTextToConsole() {
    // Test #1 - Simply write a NavText string to console to see how output is handled

    NavText navText = NavText.Create("Multiline\nvalue");
    Console.WriteLine(navText);
    Console.WriteLine();
}

void jsonObjectInitializedFromString() {
    // Test #2 - Instantiate a Newtonsoft JObject by parsing a string

    string jsonString = @"{
        'key': 'Multiline\nvalue'
    }";

    JObject jObj = JObject.Parse(jsonString);

    Console.WriteLine(jObj);
    Console.WriteLine();
}

void navJonObjectInitializedFromNavText() {
    // Test #3 - Add properties to NavJsonObject from a .Net string and a NavText

    string dotnetString = "Multiline\nvalue";

    NavText navText = NavText.Create("One\nmore\nmultiline");

    NavJsonObject navJObj = NavJsonObject.Default;

    navJObj.ALAdd(DataError.ThrowError, "key", dotnetString);
    navJObj.ALAdd(DataError.ThrowError, "anotherKey", navText);

    Console.WriteLine(navJObj); 
    Console.WriteLine();
}

void navJsonObjectInitializedByReadFrom() {
    // Test #4 - Initialize a NavJsonToken by calling ReadFrom and add the token to a NavJsonObject

    NavJsonObject navJObj = NavJsonObject.Default;
    NavJsonToken navJTok = NavJsonToken.Default;

    navJTok.ALReadFrom(DataError.ThrowError, "\"Hello\nWorld\"");
    navJObj.ALAdd(DataError.ThrowError, "key", navJTok);

    Console.WriteLine(navJObj);
    Console.WriteLine();
}

void jTokenInitializedByReadFrom() {
    // Test 5 - Code behind JsonToken.ReadFrom(Text)

    NavJsonObject navJObj = NavJsonObject.Default;

    using StringReader stringReader = new StringReader("\"Hello\\nWorld\"");
    using JsonTextReader jsonTextReader = new JsonTextReader(stringReader);
    JToken jTok = JToken.ReadFrom(jsonTextReader);
    NavJsonToken navJTok = NavJsonToken.Create(jTok);

    navJObj.ALAdd(DataError.ThrowError, "key", navJTok);

    Console.WriteLine(navJObj);
    Console.WriteLine();
}

void implicitConversionNavTextToNavJsonToken() {
    // Test #5 - Code behind JsonObject.Add(Text, Text)

    Func<NavJsonToken> initializeToken = () => {
        NavJsonValue navJValue = NavJsonValue.Default;
        navJValue.ALSetValue("\"Hello\\nWorld\"");
        return navJValue;
    };

    NavJsonObject navJObj = NavJsonObject.Default;
    navJObj.ALAdd(DataError.ThrowError, "key", initializeToken());

    Console.WriteLine(navJObj);
    Console.WriteLine();
}
