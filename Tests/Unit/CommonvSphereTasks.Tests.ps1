Describe "CommonvSphereTasks Unit Test" {
    Context "When Releasing a new version" {
        It "Should not throw" {
            $Test = $true
            $Test | Should -BeTrue
        }
    }
}