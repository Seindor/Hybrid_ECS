local RuntimePriorities = require("@Shared/Internal/Dependencies/ECS/RuntimePriorities")
local Test = require("@Shared/Internal/Dependencies/Test/Test")
local Adapter = require("@Shared/Internal/Dependencies/Test/Adapter")
local Operation = require("@Shared/Internal/Dependencies/Test/Operation")

return {
    ECS = {
        RuntimePriorities = RuntimePriorities,
    },
    Test = {
        Test = Test,
        Adapter = Adapter,
        Operation = Operation,
    },
}
