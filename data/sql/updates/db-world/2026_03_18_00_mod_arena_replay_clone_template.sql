-- Arena Replay: Actor Clone Template (safe minimal definition)

DELETE FROM `creature_template` WHERE `entry` = 98501;

INSERT INTO `creature_template`
(
    `entry`,
    `name`,
    `minlevel`,
    `maxlevel`,
    `faction`,
    `unit_class`,
    `type`,
    `unit_flags`,
    `flags_extra`,
    `AIName`,
    `MovementType`,
    `RegenHealth`
)
VALUES
(
    98501,
    'Replay Actor Clone',
    19,
    19,
    35,             -- neutral/passive faction
    1,              -- warrior class (safe default)
    7,              -- humanoid
    33554432,       -- UNIT_FLAG_NON_ATTACKABLE
    2,              -- CREATURE_FLAG_EXTRA_NO_AGGRO
    '',
    0,
    1
);

-- Model (generic humanoid fallback, overridden at runtime)
DELETE FROM `creature_template_model` WHERE `CreatureID` = 98501;

INSERT INTO `creature_template_model`
(
    `CreatureID`,
    `Idx`,
    `CreatureDisplayID`,
    `DisplayScale`,
    `Probability`
)
VALUES
(
    98501,
    0,
    27800, -- placeholder model (will be overridden by snapshot)
    1,
    1
);