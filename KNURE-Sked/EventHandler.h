//
//  EventHandler.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Shogunate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

@interface EventHandler : NSObject {
    Timer *timer;
}

/**
 Возвращает название предмета по его идентификатору
 @param id предмета
 @param Список предметов
 @param Короткое или полное название надо вернуть
 @return Строка с названием предмета
 */
- (NSString *)getBriefByID:(NSInteger)ID from:(NSArray *)subjectsList shortName:(BOOL)isShort;

/**
 Возвращает тип предмета по id типа
 @param id
 @param Список предметов
 @param Короткий или полный тип
 @return Тип предмета
 */
- (NSString *)getTypeNameByID:(NSInteger)typeID from:(NSArray *)typeList shortName:(BOOL)isShort;

/**
 Возвращает полное имя преподавателя по его идентификатору
 @param id преподавателя
 @param Спиоск где искать
 @return Строку с ФИО преподавателя
 */
- (NSString *)getFullNameByID:(NSInteger)ID from:(NSArray *)list;

/**
 Возвращает название группы по id
 @param id группы
 @param Список групп
 @result Название группы
 */
- (NSString *)getGroupNameByID:(NSInteger)ID from:(NSArray *)groupList;

/**
 Возвращает название
 @param
 @param
 @param
 @return
 */
- (NSString *)getNameFromEvent:(NSArray *)array inArray:(NSArray *)list isTeacher:(BOOL)isTeacher;

/**
 Возвращает цвет для ячейки с предметом по типу предмета
 @param Тип предмета
 @return Цвет для view
 */
- (UIColor *)getCellColorBy:(NSInteger)type;

/**
 Возвращает название предмета, тип и аудиторию из списка по индексу
 @param Индекс
 @return Название предмета
 */
- (NSString *)getLessonByIndex:(int)index;

/**
 Возвращает запакованную json строку с кодировкий UTF-8
 @param Запакованная json строка в кодировке CP1251
 @return Запакованная json строка в кодировке UTF-8
 */
- (NSData *)alignEncoding:(NSData *)data;
- (id)init;

@property (weak) NSDictionary *schedule;
@property (weak) NSArray *events;
@property (weak) NSArray *subjects;
@property (weak) NSArray *teachers;
@property (weak) NSArray *groups;
@property (weak) NSArray *types;

@end
