/**
 * Copyright (c) 2026 zSemper
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License
 */

<#-- @formatter:off -->

package ${package}.network;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public final class NbtArrayLists {
    public static ArrayList<Object> loadGlobalWorld(ListTag tag, HolderLookup.Provider lookup) {
        return loadGlobal(tag, lookup);
    }

    public static ArrayList<Object> loadGlobalMap(ListTag tag, HolderLookup.Provider lookup) {
        return loadGlobal(tag, lookup);
    }

    private static ArrayList<Object> loadGlobal(ListTag list, HolderLookup.Provider lookup) {
        ArrayList<Object> objects = new ArrayList<>();

        for (Tag tag : list) {
            CompoundTag entry = (CompoundTag) tag;

            Object value = switch(entry.getStringOr("Type", "")) {
                case "BlockState" -> NbtUtils.readBlockState(lookup.lookupOrThrow(Registries.BLOCK), entry.getCompoundOrEmpty("Value"));
                case "Direction" -> Direction.from3DDataValue(entry.getIntOr("Value", 0));
                case "ItemStack" -> ItemStack.OPTIONAL_CODEC.parse(NbtOps.INSTANCE, entry.getCompoundOrEmpty("Value")).result().orElse(ItemStack.EMPTY);
                case "Boolean" -> entry.getBooleanOr("Value", false);
                case "Double" -> entry.getDoubleOr("Value", 0.0d);
                case "String" -> entry.getStringOr("Value", "");
                case "Vec3" -> {
                    ListTag vec3List = entry.getListOrEmpty("Value");
                    yield new Vec3(vec3List.getDoubleOr(0, 0.0d), vec3List.getDoubleOr(1, 0.0d), vec3List.getDoubleOr(2, 0.0d));
                }
                case "File" -> new File(entry.getStringOr("Value", ""));
                case "JsonObject" -> JsonParser.parseString(entry.getStringOr("Value", "")).getAsJsonObject();
                case "JsonArray" -> JsonParser.parseString(entry.getStringOr("Value", "")).getAsJsonArray();
                default -> entry.getStringOr("Value", "");
            };

            objects.add(value);
        }

        return objects;
    }

    public static ListTag saveGlobalWorld(ArrayList<Object> list) {
        return saveGlobal(list);
    }

    public static ListTag saveGlobalMap(ArrayList<Object> list) {
        return saveGlobal(list);
    }

    private static ListTag saveGlobal(ArrayList<Object> list) {
        ListTag listTag = new ListTag();

        for (int i = 0; i < list.size(); i++) {
            CompoundTag entry = new CompoundTag();
            entry.putString("Type", list.get(i).getClass().getSimpleName());

            switch (list.get(i)) {
                case BlockState blockState -> entry.put("Value", NbtUtils.writeBlockState(blockState));
                case Direction direction -> entry.putInt("Value", direction.get3DDataValue());
                case ItemStack itemStack -> entry.put("Value", (CompoundTag) ItemStack.OPTIONAL_CODEC.encode(itemStack, NbtOps.INSTANCE, new CompoundTag()).result().orElse(new CompoundTag()));
                case Boolean bool -> entry.putBoolean("Value", bool);
                case Double doub -> entry.putDouble("Value", doub);
                case String str -> entry.putString("Value", str);
                case Vec3 vec -> {
                    ListTag vec3List = new ListTag();
                    vec3List.add(DoubleTag.valueOf(vec.x));
                    vec3List.add(DoubleTag.valueOf(vec.y));
                    vec3List.add(DoubleTag.valueOf(vec.z));
                    entry.put("Value", vec3List);
                }
                case File file -> entry.putString("Value", file.getPath());
                case JsonObject jsObj -> entry.putString("Value", jsObj.toString());
                case JsonArray jsArr -> entry.putString("Value", jsArr.toString());
                default -> entry.putString("Value", String.valueOf(list.get(i)));
            }

            listTag.add(entry);
        }

        return listTag;
    }
}

<#-- @formatter:on -->