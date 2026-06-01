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

            Object value = switch(entry.getString("Type")) {
                case "BlockState" -> NbtUtils.readBlockState(lookup.lookupOrThrow(Registries.BLOCK), entry.getCompound("Value"));
                case "Direction" -> Direction.from3DDataValue(entry.getInt("Value"));
                case "ItemStack" -> ItemStack.parseOptional(lookup, entry.getCompound("Value"));
                case "Boolean" -> entry.getBoolean("Value");
                case "Double" -> entry.getDouble("Value");
                case "String" -> entry.getString("Value");
                case "Vec3" -> {
                    ListTag vec3List = entry.getList("Value", Tag.TAG_DOUBLE);
                    yield new Vec3(vec3List.getDouble(0), vec3List.getDouble(1), vec3List.getDouble(2));
                }
                case "File" -> new File(entry.getString("Value"));
                case "JsonObject" -> JsonParser.parseString(entry.getString("Value")).getAsJsonObject();
                case "JsonArray" -> JsonParser.parseString(entry.getString("Value")).getAsJsonArray();
                default -> entry.getString("Value");
            };

            objects.add(value);
        }

        return objects;
    }

    public static ListTag saveGlobalWorld(ArrayList<Object> list, HolderLookup.Provider lookup) {
        return saveGlobal(list, lookup);
    }

    public static ListTag saveGlobalMap(ArrayList<Object> list, HolderLookup.Provider lookup) {
        return saveGlobal(list, lookup);
    }

    private static ListTag saveGlobal(ArrayList<Object> list, HolderLookup.Provider lookup) {
        ListTag listTag = new ListTag();

        for (int i = 0; i < list.size(); i++) {
            CompoundTag entry = new CompoundTag();
            entry.putString("Type", list.get(i).getClass().getSimpleName());

            switch (list.get(i)) {
                case BlockState blockState -> entry.put("Value", NbtUtils.writeBlockState(blockState));
                case Direction direction -> entry.putInt("Value", direction.get3DDataValue());
                case ItemStack itemStack -> entry.put("Value", itemStack.saveOptional(lookup));
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