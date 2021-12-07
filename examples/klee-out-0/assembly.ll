; ModuleID = 'get_sign.bc'
source_filename = "get_sign.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [59 x i8] c"/home/slowbro/klee/runtime/Intrinsic/klee_div_zero_check.c\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @get_sign(i32 %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  %4 = load i32, i32* %3, align 4
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %1
  store i32 0, i32* %2, align 4
  br label %12

7:                                                ; preds = %1
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %7
  store i32 -1, i32* %2, align 4
  br label %12

11:                                               ; preds = %7
  store i32 1, i32* %2, align 4
  br label %12

12:                                               ; preds = %11, %10, %6
  %13 = load i32, i32* %2, align 4
  ret i32 %13
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %4 = bitcast i32* %2 to i8*
  call void @klee_make_symbolic(i8* %4, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0))
  %5 = load i32, i32* %2, align 4
  %6 = add nsw i32 %5, 5
  %int_cast_to_i64 = zext i32 %6 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i64)
  %7 = sdiv i32 1000, %6, !klee.check.div !9
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %2, align 4
  %9 = call i32 @get_sign(i32 %8)
  ret i32 %9
}

declare void @klee_make_symbolic(i8*, i64, i8*) #1

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @klee_div_zero_check(i64 %0) #2 !dbg !10 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !15, metadata !DIExpression()), !dbg !16
  %3 = load i64, i64* %2, align 8, !dbg !17
  %4 = icmp eq i64 %3, 0, !dbg !19
  br i1 %4, label %5, label %6, !dbg !20

5:                                                ; preds = %1
  call void @klee_report_error(i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.3, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i64 0, i64 0)) #5, !dbg !21
  unreachable, !dbg !21

6:                                                ; preds = %1
  ret void, !dbg !22
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #4

attributes #0 = { noinline nounwind optnone sspstrong uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline nounwind sspstrong uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { noreturn "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5, !5}
!llvm.dbg.cu = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 12.0.1"}
!6 = distinct !DICompileUnit(language: DW_LANG_C89, file: !7, producer: "clang version 12.0.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "/home/slowbro/klee/runtime/Intrinsic/klee_div_zero_check.c", directory: "/home/slowbro/klee/build/runtime/Intrinsic")
!8 = !{}
!9 = !{!"True"}
!10 = distinct !DISubprogram(name: "klee_div_zero_check", scope: !11, file: !11, line: 12, type: !12, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !8)
!11 = !DIFile(filename: "runtime/Intrinsic/klee_div_zero_check.c", directory: "/home/slowbro/klee")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!15 = !DILocalVariable(name: "z", arg: 1, scope: !10, file: !11, line: 12, type: !14)
!16 = !DILocation(line: 12, column: 36, scope: !10)
!17 = !DILocation(line: 13, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !10, file: !11, line: 13, column: 7)
!19 = !DILocation(line: 13, column: 9, scope: !18)
!20 = !DILocation(line: 13, column: 7, scope: !10)
!21 = !DILocation(line: 14, column: 5, scope: !18)
!22 = !DILocation(line: 15, column: 1, scope: !10)
