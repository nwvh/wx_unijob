# How to create new jobs

- Open your unijob config (`configs/unijob_config.lua`)
- Go to `wx.Jobs` and define a new Key-Value pair table:
```lua
['jobname'] = {

}
```
- or just copy over an existing job
- restart the resource and refresh your jobs (/refreshjobs on ESX), or restart the whole server

* A great example is the police job in default config

## Available options:

- label: `string`
    - The job label that will be saved in database and used ingame
- whitelisted: `boolean`
    - Is the job whitelisted? (the job is not for everyone, unlike jobs like trucker etc.)
- blips: `table` (`object`)
  - blip?: `table` (`object`)
    - location: `vec3`
    - label: `string`
    - showForEveryone: `boolean`
    - sprite: `number`
    - color: `number`
    - size: `float`
- canAccess: `table` (`object`)
  - handcuff: `boolean`
  - drag: `boolean`
  - vehicles: `boolean`
  - impound: `boolean`
  - invoice: `boolean`
  - repair: `boolean`
  - hijack: `boolean`
  - idcard: `boolean`
  - clean: `boolean`
  - putIn: `boolean`
  - putOut: `boolean`
  - revive: `boolean`
  - heal: `boolean`
- bossMenu: `table` (`object`)
  - enable: `boolean`
  - marker: `boolean`
  - location: `vec3`
  - minGrade: `number`
- cloakroom: `table` (`object`)
  - enable: `boolean`
  - marker: `boolean`
  - locations: `table (vec3)`
- grades: `table` (`object`)
  - id: `string`
  - label: `string`
  - salary: `number`
- stashes: `table` (`object`)
  - label: `string`
  - location: `vec3`
  - slots: `number`
  - maxWeight: `number`
  - minGrade: `number`
  - public: `boolean`
- garages: `table` (`object`)
  - location: `vec4`
  - spawnLocations: `table (vec4)`
  - spawnInside: `boolean`
  - type: `"target" | "textui"`
  - npc: `joaat`
  - npcScenario: `string`
  - vehicles: `table` (`object`):
    - model: `joaat | number`
    - label: `string`
    - minGrade: `number`
    - livery: `number`
    - plate: `string`
- silentAlarm: `table` (`object`):
    - enable: `boolean`
    - marker: `boolean`
    - locations: `table` (`object`):
      - label: `string`
      - coords: `table (vec3)`
      - minGrade: `number`
      - items: `table` (`objects`):
        - name: `string` 
        - count: `number` 
        - license: `string` 
        - price: `number` 
        - grade: `number` 
